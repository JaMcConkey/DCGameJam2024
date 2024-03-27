extends Node
class_name ActionManager

signal actions_changed

var known_actions = []

func add_action(action_to_add : PlayerAction):
	known_actions.append(action_to_add)
	pass
func remove_action(action_to_remove : PlayerAction):
	known_actions.erase(action_to_remove)
	pass
