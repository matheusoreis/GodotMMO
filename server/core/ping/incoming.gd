class_name SPingIncoming extends RefCounted


func handle(_tree: SceneTree, _incoming: Incoming, connection: ConnectionModel) -> void:
	Multiplayer.server.send_to(
		connection,
		SPingOutgoing.new()
	)
