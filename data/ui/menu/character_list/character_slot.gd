class_name CharacterListSlot extends PanelContainer

var _id: int
@export var _name_label: Label
@export var _texture_sprite: Sprite2D
@export var _select_button: Button
@export var _delete_button: Button


func _ready() -> void:
	_select_button.pressed.connect(_on_select_pressed)
	_delete_button.pressed.connect(_on_delete_pressed)


func add_id(value: int) -> void:
	_id = value


func add_name(value: String) -> void:
	_name_label.text = value


func add_texture(value: String) -> void:
	var skin_texture: CompressedTexture2D = load(
		'res://assets/graphics/characters/' + value + '.png'
	)
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
	Multiplayer.client.send(
		CSelectCharacterOutgoing.new(
			_id
		)
	)


func _on_delete_pressed() -> void:
	Multiplayer.client.send(
		CDeleteCharacterOutgoing.new(
			_id
		)
	)
