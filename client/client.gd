class_name Client extends Node


signal client_connected()
signal client_disconnected(connection: ConnectionModel)
signal client_error(message: String)
signal received_packed(packed: PackedByteArray)


var _socket: ENetConnection
var _connection: ConnectionModel


func client_is_connected() -> bool:
	return _connection != null and _connection.peer != null


func connect_to_server() -> void:
	if client_is_connected():
		client_error.emit("Já está conectado a um servidor.")
		return

	_socket = ENetConnection.new()
	var host: String = CConstants.host
	var port: int = CConstants.port

	var error := _socket.create_host()
	if error != OK:
		client_error.emit("Falha ao iniciar o cliente! Erro: %d" % error)
		_socket = null
		return

	var connection: ConnectionModel = ConnectionModel.new()
	connection.peer = _socket.connect_to_host(host, port)

	if connection.peer == null:
		client_error.emit("Falha ao conectar ao servidor em %s:%d" % [host, port])
		return

	_connection = connection


func process() -> void:
	if not client_is_connected():
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


func _handle_error() -> void:
	client_error.emit("Erro ao tentar iniciar o cliente!")


func _handle_connect(peer: ENetPacketPeer) -> void:
	if not client_is_connected() or _connection.peer != peer:
		return

	client_connected.emit()


func _handle_disconnect(peer: ENetPacketPeer) -> void:
	if not client_is_connected() or _connection.peer != peer:
		client_error.emit("Você não está conectado para se desconectar!")
		return

	client_disconnected.emit(_connection)
	_connection = null


func _handle_receive(peer: ENetPacketPeer) -> void:
	if not client_is_connected():
		client_error.emit("Você não está conectado para receber dados!")
		return

	if not _connection.peer.get_available_packet_count():
		return

	received_packed.emit(
		_connection.peer.get_packet()
	)


func disconnect_from_server() -> void:
	if not client_is_connected():
		client_error.emit("Não há conexão ativa para desconectar.")
		return

	_connection.peer.peer_disconnect_later()


func send_data(packet: Packet, channel: int = 0) -> void:
	if not client_is_connected():
		client_error.emit("Tentativa de enviar dados sem conexão ativa!")
		return

	var writer := StreamPeerBuffer.new()
	packet.serialize(writer)

	var packed := writer.data_array
	var error := _connection.peer.send(channel, packed, ENetPacketPeer.FLAG_RELIABLE)
	if error != OK:
		client_error.emit("Falha ao enviar o pacote para o servidor! Erro: %d" % error)
