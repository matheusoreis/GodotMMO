class_name WorldModel extends Resource


var _id: int
var _name: String
var _moral: String
var _size: Vector2
var _characters: Array[CharacterModel]


var id: int:
	get:
		return _id
	set(value):
		if value >= 0:
			_id = value


var name: String:
	get:
		return _name
	set(value):
		_name = value


var moral: String:
	get:
		return _moral
	set(value):
		_moral = value


var size: Vector2:
	get:
		return _size
	set(value):
		_size = value


var characters: Array[CharacterModel]:
	get:
		return _characters
	set(value):
		if value is Array:
			_characters = value
