class_name SDeleteCharacter extends Packet


var character_id: int = -1
var success_message: String = ""
var error_messages: Array[String] = []


func _init():
	header = Packets.DELETE_CHARACTER


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	if not error_messages.is_empty():
		writer.put_u8(int(true))
		writer.put_u8(error_messages.size())
		for error in error_messages:
			writer.put_utf8_string(error)
		return

	writer.put_u8(int(false))
	writer.put_utf8_string(success_message)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)

	character_id = reader.get_u32()


func handle(_tree: SceneTree, id: int = -1) -> void:
	if id == -1:
		return

	var user: UserModel = SGlobals.users[id]
	var endpoint = SConstants.backend_endpoint + "character"

	var headers = {
		"Content-Type": "application/json",
		"Authorization": SConstants.backend_token
	}

	var body = {
		"id": user.id,
		"character_id": character_id,
	}

	var result := await Fetcher.fetch_json(HTTPClient.METHOD_DELETE, endpoint, body, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 200:
		error_messages.append_array(Fetcher.format_errors(response_data))
		Multiplayer.server.send_to(id, self)
		return

	if not ("message" in response_data):
		error_messages.append("Erro na resposta ao apagar o seu personagem.")
		Multiplayer.server.send_to(id, self)
		return

	success_message = response_data["message"]
	Multiplayer.server.send_to(id, self)
