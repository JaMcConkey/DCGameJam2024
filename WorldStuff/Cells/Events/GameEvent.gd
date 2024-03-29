extends Resource
class_name GameEvent

signal started_event(event : GameEvent)
signal resolved_event(event : GameEvent)

func start_event() -> void:
	pass
