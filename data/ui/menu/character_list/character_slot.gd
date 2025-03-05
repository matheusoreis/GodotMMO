class_name CharacterListSlot extends PanelContainer

@export_group("Nodes")
@export_subgroup('Labels')
@export var _name_label: Label

@export_subgroup('Sprites')
@export var _texture_sprite: AnimatedSprite2D

@export_subgroup("Buttons")
@export var select_button: Button
@export var delete_button: Button


var character_id: int


func add_name(value: String) -> void:
	_name_label.text = value


func add_texture(value: String) -> void:
	var skin_texture: SpriteFrames = load(
		'res://data/characters/' + value + '.tres'
	)

	_texture_sprite.sprite_frames = skin_texture


func add_direction(value: Vector2) -> void:
	if value == Vector2.DOWN:
		_texture_sprite.play("walking_down")
	elif value == Vector2.LEFT:
		_texture_sprite.play("walking_left")
	elif value == Vector2.RIGHT:
		_texture_sprite.play("walking_right")
	elif value == Vector2.UP:
		_texture_sprite.play("walking_up")


func _on_select_pressed() -> void:
	select_button.disabled = true
	delete_button.disabled = true


func _on_delete_pressed() -> void:
	select_button.disabled = true
	delete_button.disabled = true

	var packet := CDeleteCharacter.new()
	packet.character_id = character_id

	Multiplayer.client.send(packet)
