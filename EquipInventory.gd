extends Control
class_name EquipInventory
const SlotScene = preload("res://Inventory/inventory_slot.tscn")

@onready var helm = $Helm
@onready var chest = $Chest
@onready var legs = $Legs
@onready var boots = $Boots
@onready var main_hand = $MainHand
@onready var off_hand = $OffHand
func init_equip_inventory():
	var equip_con = PlayerManager.player.equip_controller
	equip_con.helm_slot_inventory.inventory_updated.connect(set_helm_data)
	equip_con.chest_slot_inventory.inventory_updated.connect(set_chest_data)
	equip_con.leg_slot_inventory.inventory_updated.connect(set_legs_data)
	equip_con.feet_slot_inventory.inventory_updated.connect(set_boots_data)
	equip_con.weapon_slot_inventory.inventory_updated.connect(set_main_hand_data)
	equip_con.offhand_slot_inventory.inventory_updated.connect(set_off_hand_data)
	set_helm_data(equip_con.helm_slot_inventory)
	set_chest_data(equip_con.chest_slot_inventory)
	set_legs_data(equip_con.leg_slot_inventory)
	set_boots_data(equip_con.feet_slot_inventory)
	set_main_hand_data(equip_con.weapon_slot_inventory)
	set_off_hand_data(equip_con.offhand_slot_inventory)
func set_helm_data(inventory_data : InventoryData):
	set_inventory_data(inventory_data, helm)

func set_chest_data(inventory_data : InventoryData):
	set_inventory_data(inventory_data, chest)

func set_legs_data(inventory_data : InventoryData):
	set_inventory_data(inventory_data, legs)

func set_boots_data(inventory_data : InventoryData):
	set_inventory_data(inventory_data, boots)

func set_main_hand_data(inventory_data : InventoryData):
	set_inventory_data(inventory_data, main_hand)

func set_off_hand_data(inventory_data : InventoryData):
	set_inventory_data(inventory_data, off_hand)


#
##var equip_slots : Array[EquipInventoryData]
#func init_equip_inventory():
	#var equip_con = PlayerManager.player.equip_controller
	#equip_con.helm_slot_inventory.inventory_updated.connect(set_helm_data)
	#equip_con.chest_slot_inventory.inventory_updated.connect(set_chest_data)
	##FOR NOW THE ORDER MUST MATCH FROM PLAYER AND THE CHILDREN HERE
	##equip_slots = PlayerManager.player.equip_inventory_data
	##for slot in equip_slots:
		##slot.inventory_updated.connect(set_inventory_data)
		##set_inventory_data(slot)
#
#func set_helm_data(inventory_data : InventoryData):
	#set_inventory_data(inventory_data,helm)
	#pass
#func set_chest_data(inventory_data : InventoryData):
	#set_inventory_data(inventory_data,chest)
	#pass
#

func set_inventory_data(inventory_data : InventoryData, ui_element) -> void:
	# Clear existing slots in each holder
	#for holder in get_children():
	for child in ui_element.get_children():
		child.queue_free()
	for slot_data in inventory_data.slot_datas:
			var slot = SlotScene.instantiate()
			ui_element.add_child(slot)
			
			slot.slot_clicked.connect(inventory_data.on_slot_clicked)
			if slot_data != null:
				slot.set_slot_data(slot_data)
	## Populate each holder with corresponding slot data
	#for index in range(min(get_child_count(), equip_slots.size())):
		#var holder = get_child(index)
		#var equip_slot = equip_slots[index]
		#for slot_data in equip_slot.slot_datas:
			#var slot = SlotScene.instantiate()
			#holder.add_child(slot)
			#slot.slot_clicked.connect(equip_slot.on_slot_clicked)
			#if slot_data != null:
				#slot.set_slot_data(slot_data)
