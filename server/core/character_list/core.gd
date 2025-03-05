class_name SCharacterList extends Packet


var max_character_slots: int = 3
var characters: Array[CharacterModel] = []
var error_messages: Array[String] = []


func _init():
	header = Packets.CHARACTER_LIST


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	# Verifica se há erros
	if not error_messages.is_empty():
		# Indica que há erros
		writer.put_u8(int(true))
		# Escreve a quantidade de erros
		writer.put_u8(error_messages.size())
		# Serializa cada erro
		for error in error_messages:
			writer.put_utf8_string(error)
		return

	# Indica que não há erros
	writer.put_u8(int(false))

	# Serializa a quantidade e máxima de personagens
	writer.put_u8(characters.size())
	writer.put_u8(max_character_slots)

	# Serializa cada personagem
	for character in characters:
		writer.put_u32(character.id)
		writer.put_utf8_string(character.name)
		writer.put_utf8_string(character.skin)
		writer.put_float(character.direction.x)
		writer.put_float(character.direction.y)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)


func handle(_tree: SceneTree, id: int = -1) -> void:
	if id == -1:
		return

	var user: UserModel = SGlobals.users[id]
	var endpoint = SConstants.backend_endpoint + "character/all?id=" + str(user.id)

	max_character_slots = user.max_character_slots

	var headers = {
		"Content-Type": "application/json",
		"Authorization": SConstants.backend_token
	}

	var result := await Fetcher.fetch_json(HTTPClient.METHOD_GET, endpoint, {}, headers)
	var status_code = result[1]
	var response_data = result[2]

	if status_code != 200:
		error_messages.append_array(Fetcher.format_errors(response_data))
		Multiplayer.server.send_to(id, self)
		return

	characters.clear()
	for i in response_data:
		var character := CharacterModel.new()
		character.id = i["id"]
		character.name = i["name"]
		character.skin = i["skin"]
		character.direction = Vector2(
			i["position_x"],
			i["position_y"]
		)

		characters.append(character)

	Multiplayer.server.send_to(id, self)
