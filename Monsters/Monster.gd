extends Resource
class_name Monster

@export var monster_name : String
@export var monster_image : Texture

@export var max_health : float
var current_health : float

func take_damage(amount : float):
	pass
