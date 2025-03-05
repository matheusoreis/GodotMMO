class_name SSignUp extends Packet


var major_version: int = -1
var minor_version: int = -1
var revision_version: int = -1

var email: String = ""
var password: String = ""
var error_messages: Array[String] = []


func _init():
	header = Packets.SIGN_UP


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	if not error_messages.is_empty():
		writer.put_u8(int(true))
		writer.put_u8(error_messages.size())
		for error in error_messages:
			writer.put_utf8_string(error)
		return

	writer.put_u8(int(false))


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)

	major_version = reader.get_u16()
	minor_version = reader.get_u16()
	revision_version = reader.get_u16()
	email = reader.get_utf8_string()
	password = reader.get_utf8_string()


func handle(_tree: SceneTree, id: int = -1) -> void:
	if id == -1:
		return

	if not _check_client_version():
		error_messages.append("O seu cliente está desatualizado!")

	var endpoint = SConstants.backend_endpoint + "authentication/sign-up"

	var headers = {
		"Content-Type": "application/json",
		"Authorization": SConstants.backend_token
	}

	var body = {
		"email": email,
		"password": password,
		"passwordConfirmation": password,
	}

	var result := await Fetcher.fetch_json(HTTPClient.METHOD_POST, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 201:
		error_messages.append_array(Fetcher.format_errors(response_data))
		Multiplayer.server.send_to(id, self)
		return

	Multiplayer.server.send_to(id, self)


func _check_client_version() -> bool:
	return major_version == SConstants.major_version and minor_version == SConstants.minor_version and revision_version == SConstants.revision_version
