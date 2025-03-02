extends PanelContainer


@onready var _create_button: Button = $content/create


func _ready() -> void:
	_create_button.pressed.connect(_on_create_pressed)


func _on_create_pressed() -> void:
	CGlobals.menu_interface.hide_interface('character_list')
	CGlobals.menu_interface.show_interface('create_character')
