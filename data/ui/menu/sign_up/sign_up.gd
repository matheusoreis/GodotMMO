class_name SignUp extends PanelContainer


@onready var close_button: Button = $content/top_bar/margin/close
@onready var email_line: LineEdit = $content/margin/content/inputs/email
@onready var password_line: LineEdit = $content/margin/content/inputs/password
@onready var repassword_line: LineEdit = $content/margin/content/inputs/repassword
@onready var sign_up_button: Button = $content/margin/content/buttons/sign_up
@onready var back_button: Button = $content/margin/content/buttons/back


func _ready() -> void:
	self.gui_input.connect(_on_gui_input)

	for child in get_children():
		_change_mouse_filter(child)

	close_button.pressed.connect(_on_close_pressed)
	sign_up_button.pressed.connect(_on_sign_up_pressed)
	back_button.pressed.connect(_on_back_pressed)


func _change_mouse_filter(control: Control) -> void:
	control.mouse_filter = Control.MOUSE_FILTER_PASS
	for child in control.get_children():
		_change_mouse_filter(child)


func _on_gui_input(ev: InputEvent) -> void:
	if ev is InputEventMouseButton:
		self.get_parent().move_child(self, self.get_parent().get_child_count() - 1)


func _on_close_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("sign_in")


func _on_sign_up_pressed() -> void:
	if email_line.text.is_empty() or password_line.text.is_empty() or repassword_line.text.is_empty():
		Notification.show([
			"Por favor, preencha todos os campos."
		])
		return

	if password_line.text != repassword_line.text:
		Notification.show([
			'As senhas não estão iguais!'
		])
		return

	Multiplayer.client.send(
		CSignUpOutgoing.new(
			email_line.text,
			password_line.text
		)
	)

	sign_up_button.disabled = true


func _on_back_pressed() -> void:
	hide()
	CGlobals.menu_interface.show_interface("sign_in")
