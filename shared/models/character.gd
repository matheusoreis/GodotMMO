class_name CharacterModel extends Resource


var id: int:
	set(value):
		if value >= 0:
			id = value

var name: String:
	set(value):
		name = value

var skin: String:
	set(value):
		skin = value

var direction: Vector2:
	set(value):
		direction = value

var world: WorldModel:
	set(value):
		if value is WorldModel:
			world = value

var position: Vector2:
	set(value):
		position = value
