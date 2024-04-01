extends Node
class_name PlayerActionManager
signal learned_action(action_learned : PlayerAction)
signal action_points_updated(action_manager : PlayerActionManager)

@export var base_off_ap : int = 1
@export var base_def_ap : int = 1
var total_off_ap : int
var total_def_ap : int


var off_per_bravery : int = 5
var def_per_reaction : int = 5
var player : Player
var player_stats : PlayerStats

var known_actions : Array[PlayerAction]
# Called when the node enters the scene tree for the first time.
func init_action_manager():
	player = PlayerManager.player
	player_stats = player.stats
	known_actions.clear()

func add_action(action : PlayerAction) -> void:
	known_actions.append(action)
	learned_action.emit(action)

func update_ap():
	var extra_off_ap : int
	extra_off_ap = player_stats.bravery.value / off_per_bravery
	total_off_ap = base_off_ap + extra_off_ap
	action_points_updated.emit(self)
	pass
