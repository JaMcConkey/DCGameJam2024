extends EnemyAction
class_name EnemyArmorUpAction

@export var phys_armor_gain : int
@export var mag_armor_gain : int

func do_action(enemy_slot : CombatSlot) -> void:
	if enemy_slot.monster == null:
		print("Trying to use action for null slot - Fucked up somewher")
		return
	enemy_slot.monster.physical_armor += phys_armor_gain
	enemy_slot.monster.magic_armor += mag_armor_gain
