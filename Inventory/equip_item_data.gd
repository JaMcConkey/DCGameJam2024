extends ItemData
class_name EquipItemData

@export var stat_modifier : PlayerStatMod
@export var gain_action : PlayerAction
@export var equip_slot : Enums.ARMOR_SLOT
#Only matters for weapon
@export var is_two_handed : bool = false

func use(target) -> void:
	pass


