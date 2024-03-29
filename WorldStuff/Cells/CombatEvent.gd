extends CellEvent
class_name CombatEvent

@export var combat_data : EnemyCombatData

#func start_event() -> void:
	##Start a fight, resolve when it ends
	#CombatManager.instance.combat_ended.connect(on_resolve_event)
	#CombatManager.instance.start_combat(combat_data)
#
#func on_resolve_event() -> void:
	#CombatManager.instance.combat_ended.disconnect(on_resolve_event)
	#print("SHOULD BE ENDING EVENT HERE")
	#resolved_event.emit(self)

