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

func start_combat(combat_data : EnemyCombatData):
	PlayerManager.toggle_move_and_rotate(false)
	show()
	in_combat = true
	for data in combat_data.spawn_data:
		var spawn_chance = randf_range(0,100)
		if spawn_chance < data.spawn_chance:
			if grid[data.slot] and grid[data.slot].monster == null:
				var enemy = data.enemy.duplicate()
				enemy.init_enemy()
				grid[data.slot].assign_monster(enemy)

func end_combat():
	hide()
	in_combat = false
	combat_ended.emit()
	PlayerManager.toggle_move_and_rotate(true)

func _input(event):
	if event.is_action_pressed("UseActivePlayerAction"):
		if active_player_action and hovered_slot and not resolving_action:
			resolving_action = true
			await active_player_action.process_action(hovered_slot,grid)
			resolving_action = false

func check_win() -> bool:
	for cell in grid:
		if cell.monster != null:
			return false
	return true

func _physics_process(delta):
	if in_combat:
		if check_win():
			print("SHOULD END COMBAT HERE")
			end_combat()
