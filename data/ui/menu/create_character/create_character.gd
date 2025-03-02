class_name CreateCharacter extends PanelContainer


@export var male_textures: Array[Texture2D] = []
@export var famale_textures: Array[Texture2D] = []

@onready var close_button: Button = $content/top_bar/margin/close
@onready var name_line: LineEdit = $content/margin/content/customization/margin/styles/name
@onready var confirm_button: Button = $content/margin/content/customization/margin/styles/buttons/confirm
@onready var back_button: Button = $content/margin/content/customization/margin/styles/buttons/back

var is_male: int = 1
@onready var famale_button: Button = $content/margin/content/sex/content/female
@onready var male_button: Button = $content/margin/content/sex/content/male

var current_texture_index: int = 0
@onready var texture_area: Sprite2D = $content/margin/content/sex/content/texture
@onready var next_skin_button: Button = $content/margin/content/customization/margin/styles/skin/next
@onready var previous_skin_button: Button = $content/margin/content/customization/margin/styles/skin/previous


func _ready() -> void:
	self.gui_input.connect(_on_gui_input)

	for child in get_children():
		_change_mouse_filter(child)

	close_button.pressed.connect(_on_close_pressed)
	confirm_button.pressed.connect(_on_confirm_pressed)
	back_button.pressed.connect(_on_back_pressed)

	next_skin_button.pressed.connect(_on_next_skin_pressed)
	previous_skin_button.pressed.connect(_on_previous_skin_pressed)

	male_button.pressed.connect(_on_male_selected)
	famale_button.pressed.connect(_on_female_selected)

	_update_texture()


func _change_mouse_filter(control: Node) -> void:
	if control is Control:
		control.mouse_filter = Control.MOUSE_FILTER_PASS
		for child in control.get_children():
			_change_mouse_filter(child)


func _on_gui_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton:
		self.get_parent().move_child(self, self.get_parent().get_child_count() - 1)


func _on_close_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("character_list")


func _on_confirm_pressed() -> void:
	if name_line.text.is_empty():
		Notification.show([
			"Por favor, preencha todos os campos."
		])
		return

	var textures = _get_current_textures()

	if textures.is_empty():
		return

	var selected_texture: CompressedTexture2D = textures[current_texture_index]
	var texture_path: String = selected_texture.resource_path
	var texture_file_name_extension: String = texture_path.get_file()
	var texture_file_name: String = texture_file_name_extension.get_basename()

	Multiplayer.client.send(
		CCreateCharacterOutgoing.new(
			name_line.text,
			texture_file_name
		)
	)


func _on_back_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("character_list")


func _on_next_skin_pressed() -> void:
	var textures = _get_current_textures()
	if textures.is_empty():
		return

	current_texture_index = (current_texture_index + 1) % textures.size()
	_update_texture()


func _on_previous_skin_pressed() -> void:
	var textures = _get_current_textures()
	if textures.is_empty():
		return

	current_texture_index = (current_texture_index - 1 + textures.size()) % textures.size()
	_update_texture()


func _on_male_selected() -> void:
	is_male = 1
	current_texture_index = 0
	_update_texture()


func _on_female_selected() -> void:
	is_male = 0
	current_texture_index = 0
	_update_texture()


func _update_texture() -> void:
	var textures = _get_current_textures()
	if textures.is_empty():
		texture_area.texture = null
	else:
		texture_area.texture = textures[current_texture_index]


func _get_current_textures() -> Array[Texture2D]:
	return male_textures if is_male else famale_textures
