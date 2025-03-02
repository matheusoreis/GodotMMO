class_name SignIn extends PanelContainer

@export_group("Nodes")
@export_subgroup('Top Bar')
@export var close_button: Button

@export_subgroup("Line Edits")
@export var email_line: LineEdit
@export var password_line: LineEdit

@export_subgroup("Buttons")
@export var sign_in_button: Button
@export var sign_up_button: Button


func _ready() -> void:
	self.gui_input.connect(_on_gui_input)

	for child in get_children():
		_change_mouse_filter(child)

	close_button.pressed.connect(_on_close_pressed)
	sign_in_button.pressed.connect(_on_sign_in_pressed)
	sign_up_button.pressed.connect(_on_sign_up_pressed)


func _change_mouse_filter(control: Control) -> void:
	control.mouse_filter = Control.MOUSE_FILTER_PASS
	for child in control.get_children():
		_change_mouse_filter(child)


func _on_gui_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton:
		self.get_parent().move_child(self, self.get_parent().get_child_count() - 1)


func _on_close_pressed() -> void:
	CGlobals.menu_interface.hide_interface("sign_in")


func _on_sign_in_pressed() -> void:
	if email_line.text.is_empty() || password_line.text.is_empty():
		CNotification.show([
			"Por favor, preencha todos os campos."
		])
		return

	sign_in_button.disabled = true
	#Multiplayer.client.send(
		#CSignInOutgoing.new(
			#email_line.text,
			#password_line.text
		#)
	#)



func _on_sign_up_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("sign_up")
