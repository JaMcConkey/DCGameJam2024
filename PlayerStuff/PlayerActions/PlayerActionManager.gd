extends Node
class_name PlayerActionManager
signal learned_action(action_learned : PlayerAction)
signal action_points_updated(action_manager : PlayerActionManager)
signal actions_updated(action_manager : PlayerActionManager)

@export var base_off_ap : int = 1
@export var base_def_ap : int = 1
var max_off_ap : int
var max_def_ap : int

var cur_off : int
var cur_def : int

var off_per_bravery : int = 5
var def_per_reaction : int = 5
var player : Player
var player_stats : PlayerStats

var known_actions : Array[PlayerAction]
var actions_from_equip : Array[PlayerAction]
# Called when the node enters the scene tree for the first time.
func init_action_manager():
	player = PlayerManager.player
	player_stats = player.stats
	known_actions.clear()
	for equip_slot in PlayerManager.player.equip_inventory_data:
		equip_slot.inventory_updated.connect(update_equip_actions)
		
func update_equip_actions(inventory : EquipInventoryData):
	for action in actions_from_equip:
		remove_action(action)
	actions_from_equip.clear()
	for item in player.equip_inventory_data:
		for equip in item.slot_datas:
			if not equip or not equip.item_data:
				continue
			var equip_item : EquipItemData
			equip_item = equip.item_data
			if equip_item.gain_action:
				actions_from_equip.append(equip_item.gain_action)
	for action in actions_from_equip:
		add_action(action)
	pass

func add_action(action : PlayerAction) -> void:
	known_actions.append(action)
	learned_action.emit(action)
	actions_updated.emit(self)
func remove_action(action : PlayerAction):
	known_actions.erase(action)
	actions_updated.emit(self)

func can_use_action(action : PlayerAction):
	if action.combat_action:
		if not CombatManager.instance.in_combat:
			print("NOT IN COMBAT")
			return false
	if action.offensive_point_cost > cur_off or\
	 action.defensive_point_cost > cur_def:
		return false
	return true
func use_action(action : PlayerAction):
	#This should just use action, which assigns it to the combat manager
	action.use_action()

func update_ap():
	var extra_off_ap : int
	extra_off_ap = player_stats.bravery.value / off_per_bravery
	max_off_ap = base_off_ap + extra_off_ap
	
	var extra_def_ap : int
	extra_def_ap = player_stats.reaction.value / def_per_reaction
	max_def_ap = base_def_ap + extra_def_ap
	action_points_updated.emit(self)
	pass

func consume_ap(off_ap : int, def_ap : int):
	cur_off -= off_ap
	cur_def -= def_ap
	action_points_updated.emit(self)
