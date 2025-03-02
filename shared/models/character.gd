class_name CharacterModel extends Resource


var _id: int
var _name: String
var _skin: String
var _direction: Vector2
var _world: WorldModel
var _position: Vector2
var _user: UserModel


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


var skin: String:
	get:
		return _skin
	set(value):
		_skin = value


var direction: Vector2:
	get:
		return _direction
	set(value):
		_direction = value


var world: WorldModel:
	get:
		return _world
	set(value):
		if value is WorldModel:
			_world = value


var position: Vector2:
	get:
		return _position
	set(value):
		_position = value


var user: UserModel:
	get:
		return _user
	set(value):
		if value is UserModel:
			_user = value
