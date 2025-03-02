class_name UserModel extends Resource


var _id: int
var _character: CharacterModel


var id: int:
	get:
		return _id
	set(value):
		if value >= 0:
			_id = value


var character: CharacterModel:
	get:
		return _character
	set(value):
		if value is CharacterModel:
			_character = value
