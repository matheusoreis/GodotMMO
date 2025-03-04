class_name Packet extends RefCounted


var header: int = 0


func serialize(writer: StreamPeerBuffer) -> void:
	writer.put_u16(header)


func deserialize(reader: StreamPeerBuffer) -> void:
	pass


func handle(_tree: SceneTree, id: int = -1) -> void:
	pass
