extends Node3D
class_name World
#Preloading for now, maybe do this dynamically
const cell_preload = preload("res://WorldStuff/Cells/cell.tscn")
var cell_size : int = 1
@export var map : Map
@export var player_pawn : PlayerPawn
@export var test_cell_data : CellData
@export var text_cell_event : CellEvent

var active_event : CellEvent

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

	#player_pawn.entered_new_cell.connect(handle_tile_enter)

#NOTE: This is emitted everytime a player enters a cell, we'll check for events
#and disable movement if there is one to resolve
func handle_tile_enter(cell_entered : Cell):
	var event = cell_entered.cell_event
	if event != null:
		EventHandler.do_event(event)
		#handle_event(cell_entered,event)
	#Right now my thought is for cell_entered to trigger things liek ground damage
	# scratch that, going to make it all events cell_entered.on_player_enter(player_pawn)


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
		else:
			print("ERROR: No cell data added, using default data")
			cell.init_cell(test_cell_data)
		
		if randf() < 0.15:
			cell.add_event(text_cell_event)
	#
	# Create a dictionary to map positions to cells for easy lookup
	var all_cells = {}
	for cell in cells:
		all_cells[Vector2(cell.global_position.x, cell.global_position.z)] = cell
	
	# Now, pass the dictionary to each cell to hide faces
	for cell in cells:
		cell.hide_faces(all_cells)
	#map.hide()

func get_cell_at_position(position: Vector3) -> Cell:
	var rounded_position = Vector3(int(position.x), int(position.y), int(position.z))
	for cell in cells:
		if cell.pos == rounded_position:
			return cell
	print("RETURNED NULL CELL")
	return null

func place_player_in_cell(cell : Cell):
	player_pawn.global_position = cell.pos
	handle_tile_enter(cell)

#var cached_cell : Cell
#func handle_event(cell : Cell, cell_event : CellEvent):
	#cached_cell = cell
	#active_event = cell_event
	#active_event.resolved_event.connect(end_event)
	#cell_event.start_event()
	#pass
#
#func end_event(event : CellEvent):
	#cached_cell.remove_event()
	#active_event = null
	#pass
