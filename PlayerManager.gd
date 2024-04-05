extends Node

var player : Player
var player_pawn : PlayerPawn

var can_move : bool = true
var can_rotate : bool = true
var can_change_equipment : bool = true


func use_slot_data(slot_data : InventorySlotData):
	slot_data.item_data.use(player)

func toggle_move_and_rotate(toggle : bool):
	can_move = toggle
	can_rotate = toggle
func consume_action_ap(action : PlayerAction):
	player.player_action_manager.consume_ap(action.offensive_point_cost,action.defensive_point_cost)

func fill_ap():
	player.player_action_manager.cur_off = player.player_action_manager.max_off_ap
	player.player_action_manager.cur_def = player.player_action_manager.max_def_ap
	player.player_action_manager.update_ap()
	
func _input(event):
	if can_rotate:
		if event.is_action_pressed("TurnLeft"):
			player_pawn.turn_left()
		if event.is_action_pressed("TurnRight"):
			player_pawn.turn_right()
	if can_move:
		if event.is_action_pressed("Forward"):
			player_pawn.move_forward()
			return
	if event.is_action_pressed("ToggleInventory"):
		player.toggle_inventory.emit()
	if event.is_action_released("TEST"):
		player.player_action_manager.update_ap()
		player.player_action_manager.add_action(player.test_learn_action)
