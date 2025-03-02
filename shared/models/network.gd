class_name NetworkModel extends Resource


var _peer: ENetConnection
var _id: int
var _user: UserModel


var peer: ENetConnection:
	get:
		return _peer
	set(value):
		if value is ENetConnection:
			_peer = value


var id: int:
	get:
		return _id
	set(value):
		if value >= 0:
			_id = value


var user: UserModel:
	get:
		return _user
	set(value):
		if value is UserModel:
			_user = value
