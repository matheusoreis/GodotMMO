class_name CDeleteCharacter extends Packet


var character_id: int = -1
var has_errors: bool = false
var error_count: int = -1
var success_message: String = ""
var error_messages: Array[String] = []


func _init():
	header = Packets.DELETE_CHARACTER


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	writer.put_u32(character_id)


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
	print(success_message)
	if has_errors:
		CNotification.show(error_messages)
		return

	Multiplayer.client.send(CCharacterList.new())

	if not success_message.is_empty():
		CNotification.show([success_message])
