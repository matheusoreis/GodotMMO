class_name CreateCharacter extends PanelContainer


@export_group("Nodes")
@export_subgroup('Textures')
@export var male_textures: Array[Texture2D] = []
@export var famale_textures: Array[Texture2D] = []

@export_subgroup('Top Bar')
@export var close_button: Button

@export_subgroup("Line Edits")
@export var name_line: LineEdit

var is_male: int = 1
@export_subgroup("Gender")
@export var famale_button: Button
@export var male_button: Button

var current_texture_index: int = 0
@export_subgroup("Sprite")
@export var texture_area: Sprite2D
@export var next_skin_button: Button
@export var previous_skin_button: Button

@export_subgroup("Buttons")
@export var confirm_button: Button
@export var back_button: Button


func _ready() -> void:
	self.gui_input.connect(_on_gui_input)

	for child in get_children():
		_change_mouse_filter(child)

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
		CNotification.show([
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

	#Multiplayer.client.send(
		#CCreateCharacterOutgoing.new(
			#name_line.text,
			#texture_file_name
		#)
	#)


func _on_back_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("character_list")


func _on_next_pressed() -> void:
	var textures = _get_current_textures()
	if textures.is_empty():
		return

	current_texture_index = (current_texture_index + 1) % textures.size()
	_update_texture()


func _on_previous_pressed() -> void:
	var textures = _get_current_textures()
	if textures.is_empty():
		return

	current_texture_index = (current_texture_index - 1 + textures.size()) % textures.size()
	_update_texture()


func _on_male_pressed() -> void:
	is_male = 1
	current_texture_index = 0
	_update_texture()


func _on_female_pressed() -> void:
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
