class_name CombatManager
extends PanelContainer

@export var combat_slot_scene : PackedScene
@export var back_row_holder : HBoxContainer 
@export var middle_row_holder : HBoxContainer
@export var front_row_holder : HBoxContainer

const grid_size = 3
var grid : Array[CombatSlot]
# Called when the node enters the scene tree for the first time.
func _ready():
	init_grid()

func init_grid():
	grid.clear()
	var total_slots = grid_size * grid_size
	make_row(back_row_holder,0)
	make_row(middle_row_holder,1)
	make_row(front_row_holder,2)
	for slot in grid:
		slot.on_mouse_over.connect(handle_mouse_over)
		slot.on_mouse_leave.connect(handle_mouse_leave)

func handle_mouse_over(slot : CombatSlot):
	slot.toggle_highlight(true)
	pass
func handle_mouse_leave(slot : CombatSlot):
	slot.toggle_highlight(false)
	pass
func make_row(holder, row_number):
	for i in grid_size:
		var slot = combat_slot_scene.instantiate()
		slot.initialize_slot(Vector2i(i,row_number))
		grid.append(slot)
		holder.add_child(slot)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
