class_name CPingIncoming extends RefCounted


func handle(_tree: SceneTree, _incoming: Incoming) -> void:
	var latency = round(
		Time.get_ticks_msec() - CGlobals.ping_sender_time
	)

	print(latency)
