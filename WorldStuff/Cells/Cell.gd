extends Area3D
class_name Cell

var cell_event

var walls = []
var pos = Vector3()
var lock_move : bool = false
var north_wall : MeshInstance3D
var east_wall : MeshInstance3D
var south_wall : MeshInstance3D
var west_wall : MeshInstance3D
var roof : MeshInstance3D
var floor_tile : MeshInstance3D #added _tile since floor is used
func _ready():
	walls.clear()
	north_wall = $NorthWall
	east_wall = $EastWall
	south_wall = $SouthWall
	west_wall = $WestWall
	floor_tile = $Floor
	roof = $Roof
	walls += [north_wall,east_wall,south_wall,west_wall]

func on_player_enter(player : PlayerPawn):
	pass

func init_cell(cell_data : CellData):
	floor_tile.mesh.material = cell_data.get_floor()
	roof.mesh.material = cell_data.get_roof()
	if cell_data.hide_roof:
		roof.hide()
	for wall in walls:
		wall.mesh.material = cell_data.get_walls()
	pos = global_position

func hide_faces(all_cells):
	var neighbors = [
		pos + Vector3(1, 0, 0), # Right
		pos + Vector3(-1, 0, 0), # Left
		pos + Vector3(0, 0, 1), # Forward
		pos + Vector3(0, 0, -1) # Back
	]
	for neighbor in neighbors:
		var neighbor_pos = Vector2(neighbor.x, neighbor.z)
		if all_cells.has(neighbor_pos):
			if neighbor == pos + Vector3.RIGHT:
				east_wall.hide()
			elif neighbor == pos + Vector3.LEFT:
				west_wall.hide()
			elif neighbor == pos + Vector3.FORWARD:
				north_wall.hide()
			elif neighbor == pos + Vector3.BACK:
				south_wall.hide()

func add_event(event):
	cell_event = event
	$EventVisual.texture = event.sprite
