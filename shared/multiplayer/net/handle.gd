class_name Handler extends RefCounted


func handle(tree: SceneTree, incoming: Incoming, handlers: Dictionary, connection: ConnectionModel = null) -> void:
	var packet: int = incoming.get_id()

	if not handlers.has(packet):
		return

	var handler_obj: RefCounted = handlers[packet]
	if not (handler_obj is RefCounted and handler_obj.has_method("handle")):
		return

	var args: Array = [tree, incoming]

	if connection != null:
		args.append(connection)

	var expected_arg_count: int = handler_obj.get_method_argument_count("handle")
	var final_args: Array = args.slice(0, expected_arg_count)

	handler_obj.callv("handle", final_args)
