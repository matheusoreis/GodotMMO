class_name Handler extends RefCounted


func handle(tree: SceneTree, incoming: Incoming, handlers: Dictionary, network: NetworkModel = null) -> void:
	var packet: int = incoming.get_id()

	if handlers.has(packet):
		var handler: Callable = handlers[packet]

		if not handler.is_valid():
			return

		var args: Array = [tree, incoming]
		if network != null:
			args.append(network)

		handler.callv(args)
