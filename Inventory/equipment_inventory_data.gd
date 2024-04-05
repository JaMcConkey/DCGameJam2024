extends InventoryData
class_name EquipInventoryData

const weapon_slot_type = "res://Inventory/EquipSlots/Weapon.tres"
const offhand_slot_type = "res://Inventory/EquipSlots/Offhand.tres"
@export var required_equip_type : EquipSlotType
#@export var required_equip_type : Array[EquipSlotType]

func drop_slot_data(grabbed_slot_data: InventorySlotData, index: int) -> InventorySlotData:
	if CombatManager.instance.in_combat:
		print("CANT EQUIP IN COMBAT")
		return grabbed_slot_data
	
	if grabbed_slot_data == null:
		print("No grabbed slot data.")
		return grabbed_slot_data
	# If it's not EquipItemData, or if the slot is not an equip slot we'll bail
	if not grabbed_slot_data.item_data is EquipItemData:
		print("WAS NOT OF TYPE EQUIPITEMDATA")
		return grabbed_slot_data
	if grabbed_slot_data.item_data is WeaponItemData:
		if grabbed_slot_data.item_data.two_handed:
				if PlayerManager.player.has_offhand():
					return grabbed_slot_data
	if not PlayerManager.can_change_equipment:
		return grabbed_slot_data
	var data = grabbed_slot_data.item_data as EquipItemData
	if not data.equip_slot_type == required_equip_type:
		print("TYPE MISMATCH")
		return grabbed_slot_data

	# Call superclass method with correct arguments
	return super.drop_slot_data(grabbed_slot_data, index)

func get_equip_item_datas() -> Array[EquipItemData]:
	var equip_item_datas = []
	for slot_data in slot_datas:
		if slot_data and slot_data.item_data is EquipItemData:
			var equip_data = slot_data.item_data as EquipItemData
			equip_item_datas.append(equip_data)
	return equip_item_datas
