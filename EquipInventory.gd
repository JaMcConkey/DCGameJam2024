extends Control
class_name EquipInventory
const SlotScene = preload("res://Inventory/inventory_slot.tscn")


var equip_slots : Array[EquipInventoryData]
func init_equip_inventory():
	#FOR NOW THE ORDER MUST MATCH FROM PLAYER AND THE CHILDREN HERE
	equip_slots = PlayerManager.player.equip_inventory_data
	for slot in equip_slots:
		slot.inventory_updated.connect(set_inventory_data)
		set_inventory_data(slot)

func set_inventory_data(inventory_data : InventoryData) -> void:
	# Clear existing slots in each holder
	for holder in get_children():
		for child in holder.get_children():
			child.queue_free()

	# Populate each holder with corresponding slot data
	for index in range(min(get_child_count(), equip_slots.size())):
		var holder = get_child(index)
		var equip_slot = equip_slots[index]
		for slot_data in equip_slot.slot_datas:
			var slot = SlotScene.instantiate()
			holder.add_child(slot)
			slot.slot_clicked.connect(equip_slot.on_slot_clicked)
			if slot_data != null:
				slot.set_slot_data(slot_data)
