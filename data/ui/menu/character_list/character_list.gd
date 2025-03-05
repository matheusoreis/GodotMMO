class_name CharacterList extends PanelContainer


@export_group("Nodes")
@export_subgroup('Content')
@export var slots_location: HBoxContainer


func update_character_panels(characters: Array[CharacterModel], max_characters: int, characters_size: int) -> void:
	var slot_scene := preload("res://data/ui/menu/character_list/character_slot.tscn") as PackedScene
	var create_slot_scene := preload("res://data/ui/menu/character_list/create_slot.tscn") as PackedScene

	for child in slots_location.get_children() as Array[Node]:
		child.queue_free()

	for i in range(characters_size):
		var character := characters[i] as CharacterModel

		var slot := slot_scene.instantiate() as CharacterListSlot
		slot.name = str(character.id)
		slot.character_id = character.id
		slot.add_name(character.name)
		slot.add_texture(character.skin)
		slot.add_direction(character.direction)

		slots_location.add_child(slot)

	var remaining_slots = max_characters - characters_size
	for i in range(remaining_slots):
		var create_slot := create_slot_scene.instantiate() as CreateCharacterSlot
		slots_location.add_child(create_slot)


func _on_close_pressed() -> void:
	Multiplayer.client.disconnect_from_server()

	CGlobals.menu_interface.hide_interface("character_list")
	CGlobals.menu_interface.show_interface("sign_in")
