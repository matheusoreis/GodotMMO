class_name CharacterListSlot extends PanelContainer

@export_group("Nodes")
@export_subgroup('Labels')
@export var _name_label: Label

@export_subgroup('Sprites')
@export var _texture_sprite: Sprite2D

@export_subgroup("Buttons")
@export var select_button: Button
@export var delete_button: Button


var character_id: int


func add_name(value: String) -> void:
	_name_label.text = value


func add_texture(value: String) -> void:
	var skin_texture := load(
		'res://assets/characters/' + value + '.png'
	) as CompressedTexture2D
	_texture_sprite.texture = skin_texture


func add_direction(value: Vector2) -> void:
	if value == Vector2.DOWN:
		_texture_sprite.frame = 0
	elif value == Vector2.LEFT:
		_texture_sprite.frame = 4
	elif value == Vector2.RIGHT:
		_texture_sprite.frame = 8
	elif value == Vector2.UP:
		_texture_sprite.frame = 12


func _on_select_pressed() -> void:
	select_button.disabled = true
	delete_button.disabled = true


func _on_delete_pressed() -> void:
	select_button.disabled = true
	delete_button.disabled = true

	var packet := CDeleteCharacter.new()
	packet.character_id = character_id

	Multiplayer.client.send(packet)
