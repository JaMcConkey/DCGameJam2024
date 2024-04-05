extends InventoryData
class_name EquipInventoryData


func drop_slot_data(grabbed_slot_data: InventorySlotData\
, index: int) -> InventorySlotData:
	
	if PlayerManager.player.equip_controller\
	.valid_drop_equip_slot(grabbed_slot_data,self):
	## Call superclass method with correct arguments
		return super.drop_slot_data(grabbed_slot_data, index)
	else:
		return grabbed_slot_data



func get_equip_item_datas() -> Array[EquipItemData]:
	var equip_item_datas = []
	for slot_data in slot_datas:
		if slot_data and slot_data.item_data is EquipItemData:
			var equip_data = slot_data.item_data as EquipItemData
			equip_item_datas.append(equip_data)
	return equip_item_datas
