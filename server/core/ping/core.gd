class_name SPing extends Packet


func _init():
	header = Packets.PING


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)


func handle(_tree: SceneTree, connection = null) -> void:
	Multiplayer.server.send_to(connection, SPing.new())
