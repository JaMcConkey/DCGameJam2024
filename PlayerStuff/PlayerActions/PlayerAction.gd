extends Resource
class_name PlayerAction

signal start_resolve
signal end_resolve

@export var action_name : String = "NEW ACTION"
@export var offensive_point_cost : int
@export var defensive_point_cost : int
@export var use_weapon_targeting : bool
@export var targeting : GridTargeting
@export var player_action_effects : Array[PlayerActionEffect]

var current_effect_index := -1
var effected_slots := []

func use_action():
	if CombatManager.instance.in_combat:
		CombatManager.instance.set_active_action(self)

func process_action(cast_slot : CombatSlot, grid : Array[CombatSlot]):
	start_resolve.emit()
	effected_slots = targeting.get_effected_slots(cast_slot, grid)
	current_effect_index = -1 # Reset the index
	apply_next_effect()

func apply_next_effect():
	current_effect_index += 1
	if current_effect_index < player_action_effects.size():
		var effect = player_action_effects[current_effect_index]
		effect.effect_resolved.connect(_on_effect_resolved)
		for slot in effected_slots:
			effect.apply_to_slot(slot)
	else:
		end_resolve.emit()

func _on_effect_resolved():
	# Proceed to the next effect
	apply_next_effect()

func _on_effect_resolved_completed():
	# Check if all effects have been resolved
	if current_effect_index + 1 == player_action_effects.size():
		end_resolve.emit()
	else:
		# Apply the next effect
		apply_next_effect()
