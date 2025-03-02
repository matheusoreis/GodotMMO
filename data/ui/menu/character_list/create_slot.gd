class_name CreateCharacterSlot extends PanelContainer

@export_group("Nodes")
@export_subgroup('Buttons')
@export var _create_button: Button


func _on_create_pressed() -> void:
	CGlobals.menu_interface.hide_interface('character_list')
	CGlobals.menu_interface.show_interface('create_character')
