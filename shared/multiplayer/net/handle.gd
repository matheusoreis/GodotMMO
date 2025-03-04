class_name Handler extends RefCounted


var packets: Dictionary = {}


func _init(packets_registry: Array[Packet] = []) -> void:
	for packet in packets_registry:
		packets[packet.header] = packet


func handle(tree: SceneTree, packed: PackedByteArray, id: int = -1) -> void:
	if packed.size() < 2:
		return

	var reader = StreamPeerBuffer.new()
	reader.data_array = packed
	reader.seek(0)

	var header = reader.get_u16()
	if not packets.has(header):
		return

	var packet: Packet = packets[header]
	if packet == null:
		return


	packet.deserialize(reader)
	packet.handle(tree, id)
