extends Node3D
class_name World
#Preloading for now, maybe do this dynamically
const cell_preload = preload("res://WorldStuff/Cells/cell.tscn")
var cell_size : int = 1
@export var map : Map
@export var player_pawn : PlayerPawn
@export var test_cell_data : CellData
@export var text_cell_event : CellEvent

var cells = []

static var instance : World
#for now just getting player pawn through child search
func _ready():
	if instance != null:
		return
	instance = self
	#var children = get_children()
	#for node in children:
		#if node is PlayerPawn:
			#player_pawn = node
			#player_pawn.entered_new_cell.connect(handle_tile_enter)
	generate_map()
	var random_cell = randi() % cells.size()
	player_pawn.global_position = cells.pick_random().global_position
	player_pawn.entered_new_cell.connect(handle_tile_enter)

#NOTE: This is emitted everytime a player enters a cell, we'll check for events
#and disable movement if there is one to resolve
func handle_tile_enter(cell_entered : Cell):
	if cell_entered.cell_event != null:
		player_pawn.toggle_move_and_rotate(false)
	#Right now my thought is for cell_entered to trigger things liek ground damage
	cell_entered.on_player_enter(player_pawn)
	pass

func generate_map():
	var tilemap = map.get_used_cells(0)
	if cell_preload == null:
		print("Error: cell_preload is null.")
		return
	for tile in tilemap:
		var cell = cell_preload.instantiate()
		add_child(cell)
		cell.global_position = Vector3(tile.x * cell_size, 0, tile.y * cell_size)
		cells.append(cell)
		var tile_data = map.get_cell_tile_data(0,tile)
		var cell_data = tile_data.get_custom_data_by_layer_id(0)
		if cell_data is CellData:
			cell.init_cell(cell_data)
			print(cell_data.test_name)
			print("SHOULD USE TILEMAP DATA HERE")
		else:
			cell.init_cell(test_cell_data)
		
		#if randf() < 0.25:
			#cell.add_event(text_cell_event)
	#
	# Create a dictionary to map positions to cells for easy lookup
	var all_cells = {}
	for cell in cells:
		all_cells[Vector2(cell.global_position.x, cell.global_position.z)] = cell
	
	# Now, pass the dictionary to each cell to hide faces
	for cell in cells:
		cell.hide_faces(all_cells)
	#map.hide()
