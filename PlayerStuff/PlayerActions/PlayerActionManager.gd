extends Node
class_name PlayerActionManager
signal learned_action(action_learned : PlayerAction)


var known_actions : Array[PlayerAction]
# Called when the node enters the scene tree for the first time.
func _ready():
	known_actions.clear()

func add_action(action : PlayerAction) -> void:
	known_actions.append(action)
	learned_action.emit(action)
