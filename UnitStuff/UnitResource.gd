extends UnitStat
class_name UnitResource
signal UnitResourceUpdated(resource : UnitResource)

@export var current_value : int 

func adjust_current(amount : int):
	current_value += amount
	if current_value > value:
		current_value = value
	UnitResourceUpdated.emit(self)

func initialize_resource():
	current_value = value
