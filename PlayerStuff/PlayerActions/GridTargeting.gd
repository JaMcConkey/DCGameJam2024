extends Resource
class_name GridTargeting

enum RANGE {Close,Medium,Long}
enum AREA {Single,Row,Column,Custom}

var custom_area #NOTE: Will be an array of Vector2i later

@export var range_type : RANGE
@export var area_type : AREA

func is_valid_slot(selected_slot : CombatSlot, grid_array : Array[CombatSlot]):
	#First we'll check for empty rows
	var first_row_empty = true
	var second_row_empty = true
	var hittable_rows = []  
	
	for slot in grid_array:
		if slot.pos.y == 2 and slot.monster != null:
			first_row_empty = false
		elif slot.pos.y == 1 and slot.monster != null:
			second_row_empty = false
	#Now we'll add hittable rows 2 (Front is always hittable)
	hittable_rows.append(2)
	match range_type:
		RANGE.Close:
			if first_row_empty:
				hittable_rows.append(1)
			if second_row_empty:
				hittable_rows.append(0)
		RANGE.Medium:
			if first_row_empty:
				hittable_rows.append(2)
				hittable_rows.append(1)
		RANGE.Long:
			hittable_rows.append(0)
			hittable_rows.append(1)
	if hittable_rows.has(selected_slot.pos.y):
		return true
	else:
		return false

func get_effected_slots(cast_slot : CombatSlot, grid_array : Array[CombatSlot]) -> Array[CombatSlot]:
	var effected_slots : Array[CombatSlot]
	match area_type:
		AREA.Single:
			effected_slots.append(cast_slot)
		AREA.Row:
			for slot in grid_array:
				if slot.pos.y == cast_slot.pos.y:
					effected_slots.append(slot)
		AREA.Column:
			for slot in grid_array:
				if slot.pos.x == cast_slot.pos.x:
					effected_slots.append(slot)
			
	return effected_slots
