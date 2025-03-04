class_name SPing extends Packet


func _init():
	header = Packets.PING


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)


func handle(_tree: SceneTree, id: int = -1) -> void:
	Multiplayer.server.send_to(id, SPing.new(), 0, false)
