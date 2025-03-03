class_name CPing extends Packet


func _init():
	header = 0


func serialize(writer: StreamPeerBuffer) -> void:
	super.serialize(writer)
	CGlobals.ping_sender_time = Time.get_ticks_msec()


func deserialize(reader: StreamPeerBuffer) -> void:
	super.deserialize(reader)


func handle(tree: SceneTree, connection = null) -> void:
	var latency = round(
		Time.get_ticks_msec() - CGlobals.ping_sender_time
	)

	print(latency)
