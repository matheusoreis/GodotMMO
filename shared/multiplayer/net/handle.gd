class_name Handler extends RefCounted


func handle(tree: SceneTree, incoming: Incoming, handlers: Dictionary, connection: ConnectionModel = null) -> void:
	var packet: int = incoming.get_id()

	if handlers.has(packet):
		var handler: Callable = handlers[packet]

		if not handler.is_valid():
			return

		var args: Array = [tree, incoming]
		if connection != null:
			args.append(connection)

		handler.callv(args)
