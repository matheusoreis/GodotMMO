class_name SSignIn extends Packet


var major_version: int = -1
var minor_version: int = -1
var revision_version: int = -1

var email: String = ""
var password: String = ""

var user: UserModel = null
var errors: Array[String] = []


func _init():
	header = Packets.SIGN_IN


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)

	if not errors.is_empty():
		writer.put_u8(int(true))
		writer.put_u8(errors.size())
		for error in errors:
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


func handle(_tree: SceneTree, connection: ConnectionModel = null) -> void:
	if connection == null:
		return

	if not _check_client_version():
		errors.append("O seu cliente está desatualizado!")

	user.database_id = 1
	Multiplayer.server.send_to(connection, SSignIn.new())


func _check_client_version() -> bool:
	return (major_version == SConstants.major_version and
			minor_version == SConstants.minor_version and
			revision_version == SConstants.revision_version)
