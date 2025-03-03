class_name CSignIn extends Packet


var _email: String = ''
var _password: String = ''

var _contains_error: bool = false
var _errors_size: int = -1
var _errors: Array[String] = []


func _init(email: String, password: String):
	header = Packets.SIGN_IN
	_email = email
	_password = password


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	writer.put_u16(CConstants.major_version)
	writer.put_u16(CConstants.minor_version)
	writer.put_u16(CConstants.revision_version)

	writer.put_utf8_string(_email)
	writer.put_utf8_string(_password)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)

	_contains_error = bool(reader.get_u8())

	if not _contains_error:
		return

	_errors_size = reader.get_u8()
	_errors.clear()
	for i in range(_errors_size):
		_errors.append(reader.get_utf8_string())


func handle(_tree: SceneTree, connection: ConnectionModel = null) -> void:
	var sign_in_ui := CGlobals.menu_interface.get_interface("sign_in") as SignIn
	sign_in_ui.sign_in_button.disabled = false
	sign_in_ui.sign_up_button.disabled = false

	if _contains_error:
		CNotification.show(_errors)
		return

	sign_in_ui.email_line.clear()
	sign_in_ui.password_line.clear()

	CGlobals.menu_interface.show_interface("character_list")
	CGlobals.menu_interface.hide_interface("sign_in")
