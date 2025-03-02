class_name UserModel extends Resource


var id: int:
	set(value):
		if value >= 0:
			id = value


var character: CharacterModel:
	set(value):
		if value is CharacterModel:
			character = value
