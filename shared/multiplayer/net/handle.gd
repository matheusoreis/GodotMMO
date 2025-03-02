class_name Handler extends RefCounted


func handle_message(tree: SceneTree, message: Incoming, packets: Dictionary, peer: int = -1) -> void:
	var packet: int = message.get_id()

	if packets.has(packet):
		var handler: Callable = packets[packet]

		if not handler.is_valid():
			return

		var args: Array = [tree, message]
		if peer != -1:
			args.append(peer)

		handler.callv(args)
