class_name NotificationUI extends Panel


var message: String = ""

@export var close_button: Button
@export var confirm_button: Button
@export var message_label: Label


func _ready() -> void:
	message_label.text = message


func _on_close_pressed() -> void:
	queue_free()


func _on_confirm_pressed() -> void:
	queue_free()
