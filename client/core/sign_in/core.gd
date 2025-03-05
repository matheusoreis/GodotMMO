class_name CSignIn extends Packet


var email: String = ''
var password: String = ''

var has_errors: bool = false
var error_count: int = -1
var error_messages: Array[String] = []


func _init():
	header = Packets.SIGN_IN


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	writer.put_u16(CConstants.major_version)
	writer.put_u16(CConstants.minor_version)
	writer.put_u16(CConstants.revision_version)

	writer.put_utf8_string(email)
	writer.put_utf8_string(password)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)

	has_errors = bool(reader.get_u8())
	if has_errors:
		error_count = reader.get_u8()
		error_messages.clear()
		for i in range(error_count):
			error_messages.append(reader.get_utf8_string())
		return


func handle(_tree: SceneTree, _id: int = -1) -> void:
	var sign_in_ui := CGlobals.menu_interface.get_interface("sign_in") as SignIn
	sign_in_ui.sign_in_button.disabled = false
	sign_in_ui.sign_up_button.disabled = false

	if has_errors:
		CNotification.show(error_messages)
		return

	sign_in_ui.email_line.clear()
	sign_in_ui.password_line.clear()

	CGlobals.menu_interface.show_interface("character_list")
	CGlobals.menu_interface.hide_interface("sign_in")

	Multiplayer.client.send(CCharacterList.new())
