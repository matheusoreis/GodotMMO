extends CanvasLayer


@onready var sign_in: SignIn = $sign_in
@onready var sign_up: SignUp = $sign_up
@onready var create_character: CreateCharacter = $create_character
@onready var character_list: CharacterList = $character_list


func _ready() -> void:
	CGlobals.menu_interface.add_interface(sign_in)
	CGlobals.menu_interface.add_interface(sign_up)
	CGlobals.menu_interface.add_interface(create_character)
	CGlobals.menu_interface.add_interface(character_list)
