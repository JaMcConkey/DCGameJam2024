extends PanelContainer
class_name InventorySlot

signal slot_clicked(index : int, button : int)
@onready var item_icon = $MarginContainer/ItemIcon
@onready var amount = $Amount

func set_slot_data(inventory_slot_data : InventorySlotData) -> void:
	var item_data = inventory_slot_data.item_data
	item_icon.texture = item_data.image
	#Will set texture,tooltips, etc here
	
	if inventory_slot_data.quantity > 1:
		amount.text = inventory_slot_data.quantity
		amount.show()
		#if it's more than 1 we'll show the quantity, if not, hide it
		pass
	else:
		amount.hide()

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(),event.button_index)
	pass # Replace with function body.
