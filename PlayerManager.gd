extends Node

var player : Player
var player_pawn : PlayerPawn

var can_move : bool = true
var can_rotate : bool = true
var can_change_equipment : bool = false


func use_slot_data(slot_data : InventorySlotData):
	slot_data.item_data.use(player)

func toggle_move_and_rotate(toggle : bool):
	can_move = toggle
	can_rotate = toggle
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
	if event.is_action_released("TEST"):
		World.instance.place_player_in_cell(World.instance.cells.pick_random())
