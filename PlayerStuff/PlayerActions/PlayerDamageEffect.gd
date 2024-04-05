extends PlayerActionEffect
class_name PlayerDamageEffect

#var damage_effect : Damage

func apply_to_slot(slot : CombatSlot) -> void:
	var monster : Enemy
	monster = slot.monster
	var damage_effect = Damage.new()
	damage_effect.phys_damage = PlayerManager.player.stats.physical_power.value
	damage_effect.mag_damage = PlayerManager.player.stats.magical_power.value
	if monster:
		monster.take_damage(damage_effect)
		await play_vfx(slot)
	#NOTE: Later will call Player.GetDamageMods on this
	#For now using Animated sprite 2d for an animation
	#slot.play_anim(anim_sprites)
	#if monster:
		#if physical_damage > 0:
			#monster.take_physical_damage(physical_damage)
		#if magical_damage > 0:
			#monster.take_magic_damage(magical_damage)
	#super.apply_to_slot(slot)
	effect_done()
