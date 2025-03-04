class_name Packet extends RefCounted


var header: int = 0


func serialize(writer: StreamPeerBuffer) -> void:
	writer.put_u16(header)


func deserialize(reader: StreamPeerBuffer) -> void:
	header = reader.get_u16()


func handle(_tree: SceneTree, id: int = -1) -> void:
	return
