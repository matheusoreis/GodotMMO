class_name CCharacterList extends Packet


var max_character_slots: int = -1
var character_count: int = -1
var characters: Array[CharacterModel]

var has_errors: bool = false
var error_count: int = -1
var error_messages: Array[String] = []


func _init():
	header = Packets.CHARACTER_LIST


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)

	has_errors = bool(reader.get_u8())
	if has_errors:
		error_count = reader.get_u8()
		error_messages.clear()
		for i in range(error_count):
			error_messages.append(reader.get_utf8_string())
		return

	character_count = reader.get_u8()
	max_character_slots = reader.get_u8()

	characters.clear()
	for i in range(character_count):
		var character := CharacterModel.new()
		character.id = reader.get_32()
		character.name = reader.get_utf8_string()
		character.skin = reader.get_utf8_string()
		character.direction = Vector2(
			reader.get_float(),
			reader.get_float()
		)

		characters.append(character)


func handle(_tree: SceneTree, _id: int = -1) -> void:
	var character_list_ui := CGlobals.menu_interface.get_interface('character_list') as CharacterList

	if has_errors:
		CNotification.show(error_messages)
		return


	character_list_ui.update_character_panels(
		characters, max_character_slots, character_count
	)
