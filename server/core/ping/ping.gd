class_name SPing extends Packet


func _init():
	header = 0


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)


func handle(tree: SceneTree, connection = null) -> void:
	Multiplayer.server.send_to(connection, SPing.new())
