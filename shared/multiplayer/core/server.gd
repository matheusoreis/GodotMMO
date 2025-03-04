class_name Server extends Node


signal accepted_connection(id: int)
signal connection_finished(id: int)
signal server_error(message: String)
signal received_packed(id: int, packed: PackedByteArray)


var _socket: ENetConnection
var _connections: Array[ConnectionModel] = []


func start() -> void:
	_connections.resize(SConstants.max_networks)
	for i in range(SConstants.max_networks):
		_connections[i] = null

	if _socket != null:
		server_error.emit("O servidor já foi iniciado!")
		return

	_socket = ENetConnection.new()
	var host: String = "0.0.0.0"
	var port: int = SConstants.port

	var error := _socket.create_host_bound(host, port, SConstants.max_networks + 1)
	if error != OK:
		server_error.emit("Falha ao iniciar o servidor! Erro: %d" % error)
		_socket = null
		return

	print_debug('Servidor inciado com sucesso na porta: ' + str(port))


func process() -> void:
	if _socket == null:
		return

	var event = _socket.service()
	if event.size() == 0:
		return

	match event[0]:
		ENetConnection.EventType.EVENT_ERROR:
			_handle_error()

		ENetConnection.EventType.EVENT_CONNECT:
			_handle_connect(event[1])

		ENetConnection.EventType.EVENT_DISCONNECT:
			_handle_disconnect(event[1])

		ENetConnection.EventType.EVENT_RECEIVE:
			_handle_receive(event[1])


func add_connection(connection: ConnectionModel) -> int:
	var index := _connections.find(null)
	if index != -1:
		_connections[index] = connection

	return index


func remove_connection(id: int) -> void:
	if id >= 0 and id < _connections.size():
		_connections[id] = null


func find_connection_by_peer(peer: ENetPacketPeer) -> ConnectionModel:
	for connection in _connections:
		if connection != null and connection.peer == peer:
			return connection
	return null


func _handle_error() -> void:
	server_error.emit("Erro ao tentar iniciar o servidor!")


func _handle_connect(peer: ENetPacketPeer) -> void:
	var connection := ConnectionModel.new()
	connection.peer = peer

	var connection_id = add_connection(connection)
	print(connection_id)
	connection.id = connection_id

	if connection_id == -1:
		server_error.emit("Servidor cheio! Não há espaço para novas conexões.")
		return

	accepted_connection.emit(connection)


func _handle_disconnect(peer: ENetPacketPeer) -> void:
	var connection := find_connection_by_peer(peer)
	var connection_id := connection.id
	if connection == null:
		return

	connection_finished.emit(connection)
	remove_connection(connection_id)


func _handle_receive(peer: ENetPacketPeer) -> void:
	var connection := find_connection_by_peer(peer)
	var connection_id := connection.id
	if connection == null:
		return

	var packed := peer.get_packet()
	if packed.size() < 2:
		disconnect_from_server(connection_id)
		return

	received_packed.emit(connection_id, packed)


func _validate_connection(connection: ConnectionModel) -> bool:
	var connection_id := connection.id

	if connection_id < 0:
		server_error.emit("Tentativa de expulsar uma conexão inexistente! ID inválido.")
		return false

	if connection_id >= _connections.size():
		server_error.emit("Tentativa de expulsar uma conexão inexistente! ID fora do limite.")
		return false

	if _connections[connection_id] != connection:
		server_error.emit("Tentativa de expulsar uma conexão inexistente! Network não corresponde.")
		return false

	return true


func disconnect_from_server(id: int) -> void:
	if id < 0 or id >= _connections.size() or _connections[id] == null:
		server_error.emit("Tentativa de desconectar uma conexão inexistente ou inválida! ID: %d" % id)
		return

	var connection := _connections[id]
	connection.peer.peer_disconnect_later()

	remove_connection(id)
	connection_finished.emit(id)


func send_to(id: int, packet: Packet, channel: int = 0, reliable: bool = true) -> void:
	if id < 0 or id >= _connections.size() or _connections[id] == null:
		server_error.emit("Tentativa de enviar para uma conexão inexistente ou inválida! ID: %d" % id)
		return

	var connection := _connections[id]

	var writer := StreamPeerBuffer.new()
	packet.serialize(writer)

	var packed := writer.data_array

	var flag := ENetPacketPeer.FLAG_RELIABLE if reliable else ENetPacketPeer.FLAG_UNSEQUENCED
	connection.peer.send(
		channel,
		packed,
		flag
	)


func send_to_all(packet: Packet, channel: int = 0, reliable: bool = true) -> void:
	for connection in _connections:
		if connection != null:
			var connection_id := connection.id
			send_to(connection_id, packet, channel, reliable)


func send_to_all_except(packet: Packet, except_id: int, channel: int = 0, reliable: bool = true) -> void:
	for connection in _connections:
		var connection_id := connection.id
		if connection != null and connection_id != except_id:
			send_to(connection_id, packet, channel, reliable)
