extends PlayerActionEffect
class_name PlayerDamageEffect

@export var physical_damage : int
@export var magical_damage : int

func apply_to_slot(slot : CombatSlot) -> void:
	var monster : Enemy
	monster = slot.monster
	var total_phys = physical_damage
	var total_mag = magical_damage
	#For now using Animated sprite 2d for an animation
	slot.play_anim(anim_sprites)
	if monster:
		if physical_damage > 0:
			monster.take_physical_damage(physical_damage)
		if magical_damage > 0:
			monster.take_magic_damage(magical_damage)
	await slot.anim_done
	super.apply_to_slot(slot)
