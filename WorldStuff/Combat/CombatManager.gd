class_name CombatManager
extends PanelContainer

signal combat_started
signal combat_ended

@export var combat_slot_scene : PackedScene
@export var back_row_holder : HBoxContainer 
@export var middle_row_holder : HBoxContainer
@export var front_row_holder : HBoxContainer

@export var test_enemy : Enemy
@export var active_player_action : PlayerAction

const grid_size = 3
static var instance : CombatManager
var grid : Array[CombatSlot]
#This is just to show what slots will be hit by the action
var effected_slots : Array[CombatSlot]
var hovered_slot : CombatSlot
var resolving_action : bool
var in_combat : bool

var turn_order : Array = []
var cur_turn_index : int = -1 #Start at -1 so first turn goes to player
var player_turn : bool
var active_enemy : Enemy

#NOTE: Recurssion is happening when the event starts before player is set in manager
func create_turn_order():
	turn_order.clear()
	cur_turn_index = -1
	turn_order.append(PlayerManager.player)
	for slot in grid:
		if slot.monster != null:
			var enemy = slot.monster
			enemy.enemy_killed.connect(remove_from_turn_order)
			turn_order.append(slot.monster)

func remove_from_turn_order(enemy_to_remove : Enemy):
	for i in range(turn_order.size()):
		if turn_order[i] == enemy_to_remove:
			turn_order.remove_at(i)
			break
	if enemy_to_remove == null:
		print("Removed null enemy from turn order.")

func next_turn():
	cur_turn_index += 1
	if cur_turn_index >= turn_order.size():
		cur_turn_index = 0
	var combatant_check = turn_order[cur_turn_index]
	#NOTE: This check was to stop recurssion when combat started before inits 
	#Should'nt be a problem later - Player should always be pos 0
	if cur_turn_index == 0 and combatant_check == null:
		turn_order[0] = PlayerManager.player
	if combatant_check == PlayerManager.player:
		PlayerManager.fill_ap()
		player_turn = true
	elif combatant_check == null:
		print("COMBATANT WASNT REMOVED? SKIPPING TUYRN")
		next_turn()
	else:
		player_turn = false
		active_enemy = turn_order[cur_turn_index]
		do_enemy_action(combatant_check)
		#Do enemy actions

func do_enemy_action(enemy : Enemy):
	#Will get one at random later, for now we'll do the first
	#NOTE: Right now i'm assigning a slot, will fix this layer
	active_enemy.assigned_slot.anim_done.connect(end_enemy_action)
	active_enemy.assigned_slot.play_attack_anim()


func end_enemy_action():
	var enemy_action = active_enemy.get_enemy_action()
	enemy_action.do_action(active_enemy.assigned_slot)
	active_enemy.assigned_slot.anim_done.disconnect(end_enemy_action)
	next_turn()

func _ready():
	if instance == null:
		instance = self
	init_grid()

func get_grid() -> Array[CombatSlot]:
	return grid

func set_active_action(action : PlayerAction):
	active_player_action = action

func init_grid():
	grid.clear()
	var total_slots = grid_size * grid_size
	make_row(back_row_holder,0)
	make_row(middle_row_holder,1)
	make_row(front_row_holder,2)
	for slot in grid:
		slot.on_mouse_over.connect(handle_mouse_over)
		slot.on_mouse_leave.connect(handle_mouse_leave)
	#Assigning null monsters for now to clear the ui
	for slot in grid:
		slot.assign_monster(null)

func handle_mouse_over(slot : CombatSlot):
	#slot.toggle_highlight(true)
	hovered_slot = slot
	if active_player_action:
		if active_player_action.targeting.is_valid_slot(hovered_slot,grid):
			slot.toggle_highlight(true)
			clear_effected()
			for new_slot in active_player_action.targeting.get_effected_slots(slot,grid):
				new_slot.toggle_effected(true)
				effected_slots.append(new_slot)
		else:
			slot.toggle_invalid(true)
	pass

func clear_effected():
	for slot in effected_slots:
		slot.toggle_effected(false)
	effected_slots.clear()

func handle_mouse_leave(slot : CombatSlot):
	hovered_slot = null
	slot.toggle_highlight(false)
	slot.toggle_invalid(false)
	clear_effected()
	pass
func make_row(holder, row_number):
	for i in grid_size:
		var slot = combat_slot_scene.instantiate()
		slot.initialize_slot(Vector2i(i,row_number))
		grid.append(slot)
		holder.add_child(slot)
	pass

func action_resolved():
	resolving_action = false

func start_combat(combat_data : EnemyCombatData):
#	PlayerManager.toggle_move_and_rotate(false)
	show()
	for data in combat_data.spawn_data:
		var spawn_chance = randf_range(0,100)
		if spawn_chance < data.spawn_chance:
			if grid[data.slot] and grid[data.slot].monster == null:
				var enemy = data.enemy.duplicate()
				enemy.init_enemy()
				grid[data.slot].assign_monster(enemy)
	in_combat = true
	create_turn_order()
	PlayerManager.fill_ap()
	next_turn()

func end_combat():
	hide()
	in_combat = false
	combat_ended.emit()
#	PlayerManager.toggle_move_and_rotate(true)

func _input(event):
	if event.is_action_pressed("UseActivePlayerAction"):
		if active_player_action and player_turn and hovered_slot and not resolving_action:
			if active_player_action.targeting.is_valid_slot(hovered_slot,grid):
				resolve_player_action(active_player_action,hovered_slot)
				
var processing_action : PlayerAction

func resolve_player_action(action : PlayerAction,cast_slot : CombatSlot):
	if not action.targeting.is_valid_slot(cast_slot,grid) or resolving_action:
		return
	resolving_action = true
	processing_action = action
	action.end_resolve.connect(end_resolve_player_action)
	action.process_action(cast_slot,grid)

func end_resolve_player_action():
	processing_action.end_resolve.disconnect(end_resolve_player_action)
	PlayerManager.consume_action_ap(processing_action)
	processing_action = null
	resolving_action = false
	active_player_action = null

func check_win() -> bool:
	for cell in grid:
		if cell.monster != null:
			return false
	return true

func _physics_process(delta):
	if active_player_action:
		$"DEBUG ACTION".text = str(active_player_action.action_name)
	else:
		$"DEBUG ACTION".text = ""
	if in_combat:
		if check_win():
			print("SHOULD END COMBAT HERE")
			end_combat()


func _on_end_turn_button_pressed():
	if player_turn:
		next_turn()
	pass # Replace with function body.
