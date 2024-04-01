extends EnemyAction
class_name EnemyAttackAction

@export var damage : Damage


func do_action(enemy_slot : CombatSlot) -> void:
	#Play an anim
	#Later will check slot for damage mods, then add them
	PlayerManager.player.take_damage(damage)
