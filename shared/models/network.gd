class_name ConnectionModel extends Resource


var peer: ENetPacketPeer:
	set(value):
		if value is ENetPacketPeer:
			peer = value

var id: int:
	set(value):
		if value >= 0:
			id = value

var user: UserModel:
	set(value):
		if value is UserModel:
			user = value
