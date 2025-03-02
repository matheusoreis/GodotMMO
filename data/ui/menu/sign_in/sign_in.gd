class_name SignIn extends PanelContainer


@onready var close_button: Button = $content/top_bar/margin/close
@onready var email_line: LineEdit = $content/margin/content/inputs/email
@onready var password_line: LineEdit = $content/margin/content/inputs/password
@onready var sign_in_button: Button = $content/margin/content/buttons/sign_in
@onready var sign_up_button: Button = $content/margin/content/buttons/sign_up


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
		Notification.show([
			"Por favor, preencha todos os campos."
		])
		return

	Multiplayer.client.send(
		CSignInOutgoing.new(
			email_line.text,
			password_line.text
		)
	)

	sign_in_button.disabled = true


func _on_sign_up_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("sign_up")
