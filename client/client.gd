extends Control


var _client: Client
var _handler: Handler


func _init() -> void:
	_client = Multiplayer.client
	_client.connect_to_server()


func _ready() -> void:
	_client.client_connected.connect(_client_connected)
	_client.client_disconnected.connect(_client_disconnected)
	_client.client_error.connect(_client_error)
	_client.received_packed.connect(_received_packed)

	_handler = Handler.new([
		CPing.new(),
		CSignIn.new(),
		CSignUp.new(),
	])


func _process(_delta: float) -> void:
	_client.process()


func _client_connected() -> void:
	print("Sucesso ao se conectar ao servidor!")


func _client_disconnected(network: ConnectionModel) -> void:
	print("Cliente desconectado do servidor, peer: ", network.peer)


func _client_error(message: String) -> void:
	print(message)


func _received_packed(packed: PackedByteArray) -> void:
	_handler.handle(get_tree(), packed)


func _on_button_pressed() -> void:
	Multiplayer.client.send(
		CPing.new(), 1, false
	)
