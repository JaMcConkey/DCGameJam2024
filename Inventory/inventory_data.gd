extends Resource
class_name InventoryData

signal inventory_updated(inventory_data : InventoryData)
signal inventory_interact(inventory_data : InventoryData,index : int, button : int)

@export var slot_datas : Array[InventorySlotData]

func grab_slot_data(index : int) -> InventorySlotData:
	var slot_data = slot_datas[index]
	 #ADDING a check for item data for equip slots
	if slot_data != null and slot_data.item_data != null:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func use_slot_data(index : int) -> void:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return
	#If it is a consumeable, we'll decerement it by 1. If we are out we'll clear the clear
	if slot_data.item_data is ConsumeableItemData:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
	if slot_data.item_data is EquipItemData:
		if PlayerManager.player.equip_controller.equip(slot_data):
			slot_datas[index] = null
		
	PlayerManager.use_slot_data(slot_data)
	inventory_updated.emit(self)

func drop_slot_data(grabbed_slot_data : InventorySlotData,index : int) -> InventorySlotData:
	var slot_data = slot_datas[index]
	
	var return_data : InventorySlotData
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_datas[index] = grabbed_slot_data
		return_data = slot_data
	inventory_updated.emit(self)
	#If somethign is there we return the item, IE Swap
	return return_data

func pick_up_slot_data(slot_data : InventorySlotData) -> bool:
	#Will check if mergeable later and then auto combime
	for index in slot_datas.size():
		if slot_datas[index] == null:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	
	return false

func on_slot_clicked(index : int, button: int) -> void:
	inventory_interact.emit(self,index,button)
