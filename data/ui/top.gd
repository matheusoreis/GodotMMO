class_name Top extends Control


@export var target_node: NodePath
var drag_offset: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var target: Control = null


func _ready() -> void:
	target = get_node(target_node)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and target:
				target.get_parent().move_child(target, target.get_parent().get_child_count() - 1)

				drag_offset = event.position
				is_dragging = true
			else:
				is_dragging = false
	elif event is InputEventMouseMotion and is_dragging and target:
		target.global_position += event.relative


func _process(_delta: float) -> void:
	if is_dragging and target:
		var mouse_position = get_global_mouse_position() - drag_offset
		var target_size = target.size
		var parent_rect = get_viewport_rect()

		mouse_position.x = clamp(mouse_position.x, 0, parent_rect.size.x - target_size.x)
		mouse_position.y = clamp(mouse_position.y, 0, parent_rect.size.y - target_size.y)

		target.global_position = mouse_position
