class_name CharacterList extends PanelContainer


@export var slots_location: HBoxContainer


func update_character_panels(characters: Array[CharacterAttributes], max_characters: int, characters_size: int) -> void:
	var slot_scene: PackedScene = preload("res://data/ui/menu/character_list/character_slot.tscn")
	var create_slot_scene: PackedScene = preload("res://data/ui/menu/character_list/create_slot.tscn")

	for child in slots_location.get_children():
		child.queue_free()

	for i in range(characters_size):
		var character = characters[i]

		var slot: CharacterListSlot = slot_scene.instantiate()
		slot.add_id(character.id)
		slot.add_name(character.name)
		slot.add_texture(character.skin)
		slot.add_direction(character.direction)

		slots_location.add_child(slot)

	var remaining_slots = max_characters - characters_size
	for i in range(remaining_slots):
		var create_slot = create_slot_scene.instantiate()
		slots_location.add_child(create_slot)
