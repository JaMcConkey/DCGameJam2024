extends Resource
class_name InventorySlotData

const MAX_STACK_SIZE : int = 99  #Might change this to be determined by the time

@export var item_data : ItemData
@export_range(1, MAX_STACK_SIZE) var quantity : int = 1: set = set_quantity


func can_merge_with(other_slot_data : InventorySlotData) -> bool:
	if item_data == other_slot_data.item_data:
		if item_data.stackable:
			if quantity < MAX_STACK_SIZE:
				return true
	return false

func can_fully_merge_with(other_slot_data : InventorySlotData) -> bool:
	if item_data == other_slot_data.item_data:
		if item_data.stackable:
			if quantity + other_slot_data.quantity < MAX_STACK_SIZE:
				return true
	return false

func fully_merge_with(other_slot_data : InventorySlotData) -> void:
	quantity += other_slot_data.quantity



func create_single_slot_data() -> InventorySlotData:
	var new_slot_data = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data

func set_quantity(value :int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error(item_data.item_name % " not stackable, setting value to 1")
	pass
