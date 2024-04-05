extends Node

@export var helm_slot_type : EquipSlotType
@export var chest_slot_type : EquipSlotType
@export var leg_slot_type : EquipSlotType
@export var feet_slot_type : EquipSlotType
@export var weapon_slot_type : EquipSlotType
@export var offhand_slot_type : EquipSlotType

@export var helm_slot_data : EquipSlotData
@export var chest_slot_data : EquipSlotData
@export var leg_slot_data : EquipSlotData
@export var feet_slot_data : EquipSlotData
@export var weapon_slot_data : EquipSlotData
@export var offhand_slot_data : EquipSlotData


var helm_item : EquipItemData
var chest_item : EquipItemData
var leg_item : EquipItemData
var feet_item : EquipItemData
var weapon_item : EquipItemData
var offhand_item : EquipItemData
func equip(equip_item_data : EquipItemData):
	match equip_item_data:
		helm_slot_type:
			pass
		chest_slot_type:
			pass
		leg_slot_type:
			pass
		feet_slot_type:
			pass
		weapon_slot_type:
			pass
		offhand_slot_type:
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
