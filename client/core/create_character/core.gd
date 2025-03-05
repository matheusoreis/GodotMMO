class_name CCreateCharacter extends Packet


var name: String = ""
var skin: String = ""
var has_errors: bool = false
var error_count: int = -1
var success_message: String = ""
var error_messages: Array[String] = []


func _init():
	header = Packets.CREATE_CHARACTER


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	writer.put_utf8_string(name)
	writer.put_utf8_string(skin)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)

	has_errors = bool(reader.get_u8())
	if has_errors:
		error_count = reader.get_u8()
		error_messages.clear()
		for i in range(error_count):
			error_messages.append(reader.get_utf8_string())
		return

	success_message = reader.get_utf8_string()


func handle(_tree: SceneTree, _id: int = -1) -> void:
	var create_character_ui := CGlobals.menu_interface.get_interface("create_character") as CreateCharacter
	create_character_ui.confirm_button.disabled = false
	create_character_ui.back_button.disabled = false

	if has_errors:
		CNotification.show(error_messages)
		return

	create_character_ui.name_line.clear()

	CGlobals.menu_interface.show_interface("character_list")
	CGlobals.menu_interface.hide_interface("create_character")

	Multiplayer.client.send(CCharacterList.new())

	if not success_message.is_empty():
		CNotification.show([success_message])
