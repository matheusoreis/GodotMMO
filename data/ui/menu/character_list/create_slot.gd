class_name CreateCharacterSlot extends PanelContainer


func _on_create_pressed() -> void:
	CGlobals.menu_interface.hide_interface('character_list')
	CGlobals.menu_interface.show_interface('create_character')
