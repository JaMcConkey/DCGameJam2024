extends Resource
class_name CellData

@export var test_name : String
@export var ground : BaseMaterial3D
@export var walls : BaseMaterial3D
@export var roof : BaseMaterial3D
@export var hide_roof : bool

func get_floor() -> BaseMaterial3D:
	return ground
func get_walls() -> BaseMaterial3D:
	return walls
func get_roof() -> BaseMaterial3D:
	return roof
