extends Resource
class_name UnitStat

signal StatUpdated(stat : UnitStat)

@export var value_name : String = ""
@export var base_value : int
var value : int : get = get_value
var _list_of_mods : Array[int]
func get_value() -> int:
	var to_return = base_value
	for mod in _list_of_mods:
		to_return += mod
		
	return to_return

#For now just going to have generic int as modifier and do flat adds - Will expand
func add_modifier(modifier : int, source = null):
	_list_of_mods.append(modifier)
	StatUpdated.emit(self)
func remove_modifier(modifier : int, source = null):
	_list_of_mods.erase(modifier)
	StatUpdated.emit(self)
