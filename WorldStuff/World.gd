extends Node3D

#Preloading for now, maybe do this dynamically
const cell_preload = preload("res://WorldStuff/Cells/cell.tscn")
var cell_size : int = 1
@export var map : Map
@export var player_pawn : PlayerPawn
@export var test_cell_data : CellData


var cells = []

#for now just getting player pawn through child search
func _ready():
	var children = get_children()
	for node in children:
		if node is PlayerPawn:
			player_pawn = node
			player_pawn.entered_new_cell.connect(handle_tile_enter)
	generate_map()
	var random_cell = randi() % cells.size()
	player_pawn.global_position = cells.pick_random().global_position

func handle_tile_enter(cell_entered : Cell):
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
		cell.init_cell(test_cell_data)
	
	# Create a dictionary to map positions to cells for easy lookup
	var all_cells = {}
	for cell in cells:
		all_cells[Vector2(cell.global_position.x, cell.global_position.z)] = cell
	
	# Now, pass the dictionary to each cell to hide faces
	for cell in cells:
		cell.hide_faces(all_cells)
	#map.hide()
