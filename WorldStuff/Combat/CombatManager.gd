class_name CombatManager
extends PanelContainer

@export var combat_slot_scene : PackedScene
@export var back_row_holder : HBoxContainer 
@export var middle_row_holder : HBoxContainer
@export var front_row_holder : HBoxContainer

@export var test_enemy : Enemy
@export var active_player_action : PlayerAction

const grid_size = 3
var grid : Array[CombatSlot]
#This is just to show what slots will be hit by the action
var effected_slots : Array[CombatSlot]
var hovered_slot : CombatSlot
var resolving_action : bool

func _ready():
	init_grid()
	var enemy_to_assign = test_enemy.duplicate()
	enemy_to_assign.init_enemy()
	grid[3].assign_monster(enemy_to_assign)
	print(grid[3].monster.current_health)

func get_grid() -> Array[CombatSlot]:
	return grid


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
	slot.toggle_highlight(true)
	hovered_slot = slot
	if active_player_action:
		slot.toggle_highlight(true)
		clear_effected()
		for new_slot in active_player_action.targeting.get_effected_slots(slot,grid):
			new_slot.toggle_effected(true)
			effected_slots.append(new_slot)
	pass

func clear_effected():
	for slot in effected_slots:
		slot.toggle_effected(false)
	effected_slots.clear()

func handle_mouse_leave(slot : CombatSlot):
	hovered_slot = null
	slot.toggle_highlight(false)
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

func _input(event):
	if event.is_action_pressed("UseActivePlayerAction"):
		if active_player_action and hovered_slot and not resolving_action:
			print("SHOULD START RESOVLE HERE")
			resolving_action = true
			await active_player_action.process_action(hovered_slot,grid)
			resolving_action = false
