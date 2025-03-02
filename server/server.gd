class_name Server extends Node


signal client_connected(network: NetworkModel)
signal client_disconnected(network: NetworkModel)
signal server_error(message: String)
signal received_packed(network: NetworkModel, packed: PackedByteArray)


var _socket: ENetConnection
var _networks: Array[NetworkModel] = []


func start() -> void:
	_networks.resize(SConstants.max_networks)
	for i in range(SConstants.max_networks):
		_networks[i] = null

	if _socket != null:
		server_error.emit("O servidor já foi iniciado!")
		return

	_socket = ENetConnection.new()
	var host: String = "0.0.0.0"
	var port: int = SConstants.port

	var error := _socket.create_host_bound(host, port)
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


func add_network(network: NetworkModel) -> int:
	var index := _networks.find(null)
	if index != -1:
		_networks[index] = network

	return index


func remove_network(id: int) -> void:
	if id >= 0 and id < _networks.size():
		_networks[id] = null


func find_network_by_peer(peer: ENetPacketPeer) -> NetworkModel:
	for network in _networks:
		if network != null and network.peer == peer:
			return network
	return null


func _handle_error() -> void:
	server_error.emit("Erro ao tentar iniciar o servidor!")


func _handle_connect(peer: ENetPacketPeer) -> void:
	var network := NetworkModel.new()
	network.peer = peer
	network.id = add_network(network)

	if network.id == -1:
		server_error.emit("Servidor cheio! Não há espaço para novos jogadores.")
		return

	client_connected.emit(network)


func _handle_disconnect(peer: ENetPacketPeer) -> void:
	var network := find_network_by_peer(peer)
	if network == null:
		return

	client_disconnected.emit(network)
	remove_network(network.id)


func _handle_receive(peer: ENetPacketPeer) -> void:
	var network := find_network_by_peer(peer)
	if network == null:
		return

	var packed := peer.get_packet()
	if packed.size() < 2:
		disconnect_from_server(network)
		return

	received_packed.emit(network, packed)


func _validate_network(network: NetworkModel) -> bool:
	if network.id < 0:
		server_error.emit("Tentativa de expulsar uma conexão inexistente! ID inválido.")
		return false

	if network.id >= _networks.size():
		server_error.emit("Tentativa de expulsar uma conexão inexistente! ID fora do limite.")
		return false

	if _networks[network.id] != network:
		server_error.emit("Tentativa de expulsar uma conexão inexistente! Network não corresponde.")
		return false

	return true


func disconnect_from_server(network: NetworkModel) -> void:
	if not _validate_network(network):
		return

	network.peer.peer_disconnect_later()


func send_to(network: NetworkModel, outgoing: Outgoing, reliable: bool = true, channel: int = 0) -> void:
	if not _validate_network(network):
		return

	var packed := outgoing.get_buffer() as PackedByteArray
	network.peer.send(channel, packed, int(reliable))


func send_to_all(outgoing: Outgoing, reliable: bool = true, channel: int = 0) -> void:
	for network in _networks:
		send_to(network, outgoing, reliable, channel)


func send_to_all_except(outgoing: Outgoing, except_network: NetworkModel, reliable: bool = true, channel: int = 0) -> void:
	for network in _networks:
		if network == except_network:
			continue

		send_to(network, outgoing, reliable, channel)
