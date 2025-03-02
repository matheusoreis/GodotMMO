class_name WorldModel extends Resource


var id: int:
	set(value):
		if value >= 0:
			id = value


var name: String:
	set(value):
		name = value


var moral: String:
	set(value):
		moral = value


var size: Vector2:
	set(value):
		size = value


var characters: Array[CharacterModel]:
	set(value):
		if value is Array[CharacterModel]:
			characters = value
