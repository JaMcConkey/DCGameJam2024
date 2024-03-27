extends Resource
class_name PlayerAction

signal start_resolve
signal end_resolve

#If we're using weapon targeting then we can ignore other targeting
@export var use_weapon_targeting : bool
@export var targeting : GridTargeting

@export var player_action_effects : Array[PlayerActionEffect]

func process_action(cast_slot : CombatSlot, grid : Array[CombatSlot]):
	start_resolve.emit()
	var effected = targeting.get_effected_slots(cast_slot,grid)
	for slot in effected:
		for effect in player_action_effects:
			effect.apply_to_slot(slot)
			await effect.effect_resolved
	end_resolve.emit()
