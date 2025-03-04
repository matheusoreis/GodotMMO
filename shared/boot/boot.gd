class_name Boot extends Control


@export var client_scene: PackedScene
@export var server_scene: PackedScene


func _on_client_pressed() -> void:
	var scene: Control = client_scene.instantiate()
	get_tree().root.add_child(scene)
	queue_free()


func _on_server_pressed() -> void:
	get_tree().root.mode = Window.MODE_MINIMIZED
	var scene: Control = server_scene.instantiate()
	get_tree().root.add_child(scene)
	queue_free()
