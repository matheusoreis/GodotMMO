extends Control


var _server: Server
var _handler: Handler

var _handlers: Dictionary = {}


func _init() -> void:
	_server = Multiplayer.server
	_server.start()


func _ready() -> void:
	_server.accepted_connection.connect(_accepted_connection)
	_server.connection_finished.connect(_connection_finished)
	_server.server_error.connect(_server_error)
	_server.received_packed.connect(_received_packed)

	_handler = Handler.new()
	_register_packets()


func _process(_delta: float) -> void:
	_server.process()


func _register_packets() -> void:
	pass


func _accepted_connection(connection: ConnectionModel) -> void:
	print_debug("Cliente conectado ao servidor: " + str(connection.id))


func _connection_finished(connection: ConnectionModel) -> void:
	print_debug("Cliente desconectado do servidor: " + str(connection.id))


func _server_error(message: String) -> void:
	print_debug("Erro no servidor, erro: " + message)


func _received_packed(connection: ConnectionModel, packed: PackedByteArray) -> void:
	if packed.size() < 2:
		_server.disconnect_from_server(connection)
		return

	var incoming := Incoming.new()
	incoming.add_packed(packed)

	_handler.handle(
		get_tree(),
		incoming,
		_handlers,
		connection
	)
