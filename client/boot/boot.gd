extends Control


var _client: Client
var _handler: Handler

var _incomings: Dictionary = {}


func _init() -> void:
	_client = Multiplayer.client
	_client.connect_to_server()


func _ready() -> void:
	_client.client_connected.connect(_client_connected)
	_client.client_disconnected.connect(_client_disconnected)
	_client.client_error.connect(_client_error)
	_client.client_received_packed.connect(_client_received_packed)

	_handler = Handler.new()
	_register_packets()


func _process(_delta: float) -> void:
	_client.process()


func _register_packets() -> void:
	pass


func _client_connected() -> void:
	print("Sucesso ao se conectar ao servidor!")


func _client_disconnected(network: NetworkModel) -> void:
	print("Cliente desconectado do servidor, peer: ", network.peer)


func _client_error(message: String) -> void:
	print(message)


func _client_received_packed(packed: PackedByteArray) -> void:
	print(packed)
