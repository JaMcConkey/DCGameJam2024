extends Node
class_name PlayerEquipController

signal equip_updated

@export var helm_slot_inventory : EquipInventoryData
@export var chest_slot_inventory : EquipInventoryData
@export var leg_slot_inventory : EquipInventoryData
@export var feet_slot_inventory : EquipInventoryData
@export var weapon_slot_inventory : EquipInventoryData
@export var offhand_slot_inventory : EquipInventoryData

func get_all_slot_invs() -> Array[EquipInventoryData]:
	var to_return : Array[EquipInventoryData] = []
	to_return.clear()
	if helm_slot_inventory != null:
		to_return.append(helm_slot_inventory)
	if chest_slot_inventory != null:
		to_return.append(chest_slot_inventory)
	if leg_slot_inventory != null:
		to_return.append(leg_slot_inventory)
	if feet_slot_inventory != null:
		to_return.append(feet_slot_inventory)
	if weapon_slot_inventory != null:
		to_return.append(weapon_slot_inventory)
	if offhand_slot_inventory != null:
		to_return.append(offhand_slot_inventory)
	return to_return
func get_slot_inventory(slot_type: int) -> EquipInventoryData:
	match slot_type:
		Enums.ARMOR_SLOT.HELM:
			return helm_slot_inventory
		Enums.ARMOR_SLOT.CHEST:
			return chest_slot_inventory
		Enums.ARMOR_SLOT.LEGS:
			return leg_slot_inventory
		Enums.ARMOR_SLOT.FEET:
			return feet_slot_inventory
		Enums.WEAPON_SLOT.TWO_HANDED:
			return weapon_slot_inventory
		Enums.WEAPON_SLOT.ONE_HANDED:
			return weapon_slot_inventory
		Enums.WEAPON_SLOT.OFFHAND:
			return offhand_slot_inventory
	return null
func valid_drop_equip_slot(slot_data : InventorySlotData, slot_to_check : EquipInventoryData):
		if slot_to_check == get_slot_inventory(slot_data.item_data.equip_slot):
				return true
		return false

func equip(slot_data : InventorySlotData) -> bool:
	if CombatManager.instance.in_combat:
		return false
	var slot = get_slot_inventory(slot_data.item_data.equip_slot)
	if slot:
		if _generic_equip(slot_data,slot):
			return true
	return false
func _generic_equip(data : InventorySlotData, slot : EquipInventoryData) -> bool:
	#IF HERE IS NOTHING THERE, EQUIP
	#IF there is lets return it to the inventory, then equip the new slot
	#Inventory should always be only 1 in length
	if slot.pick_up_slot_data(data):
		return true
	else:
		PlayerManager.player.inventory_data.pick_up_slot_data\
		(slot.grab_slot_data(0))
		slot.pick_up_slot_data(data)
	return true
func _equip_helm(data : InventorySlotData) -> bool:
	#IF HERE IS NOTHING THERE, EQUIP
	#IF there is lets return it to the inventory, then equip the new slot
	#Inventory should always be only 1 in length
	if helm_slot_inventory.pick_up_slot_data(data):
		return true
	else:
		PlayerManager.player.inventory_data.pick_up_slot_data\
		(helm_slot_inventory.grab_slot_data(0))
		helm_slot_inventory.pick_up_slot_data(data)
	return true
func _equip_chest(data : EquipItemData):
	pass
func _equip_leg(data : EquipItemData):
	pass
func _equip_feet(data : EquipItemData):
	pass
func _equip_weapon(data : WeaponItemData):
	pass
func _equip_offhand(data : WeaponItemData):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
