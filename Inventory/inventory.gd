extends PanelContainer
class_name Inventory

const SlotScene = preload("res://Inventory/inventory_slot.tscn")

@onready var inventory_grid = $MarginContainer/InventoryGrid

func set_inventory_data(inventory_data : InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_grid)
	populate_grid(inventory_data)

func populate_grid(inventory_data : InventoryData) -> void:
	for child in inventory_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = SlotScene.instantiate()
		inventory_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		if slot_data != null:
			slot.set_slot_data(slot_data)

func clear_inventory_data(inventory_data : InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_grid)

