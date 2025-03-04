extends Node


func show(messages: Array[String]) -> void:
	var notification_ui := preload(
		"res://data/ui/shared/notification/notification.tscn"
	) as PackedScene

	var notification_instance := notification_ui.instantiate() as NotificationUI
	notification_instance.message = "\n".join(messages)

	var menu := get_tree().root.get_node("client/shared") as CanvasLayer
	menu.add_child(notification_instance)
