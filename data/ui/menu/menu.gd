extends CanvasLayer


@export var sign_in: SignIn
@export var sign_up: SignUp
@export var create_character: CreateCharacter
@export var character_list: CharacterList


func _ready() -> void:
	CGlobals.menu_interface.add_interface(sign_in)
	CGlobals.menu_interface.add_interface(sign_up)
	CGlobals.menu_interface.add_interface(create_character)
	CGlobals.menu_interface.add_interface(character_list)
