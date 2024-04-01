extends Node

var active_event : GameEvent

func add_event_to_que(event : CellEvent):
	pass

func do_event(event : GameEvent) -> void:
	PlayerManager.toggle_move_and_rotate(false)
	if event is CombatEvent:
		_handle_combat_event(event)
	elif event is CellVignetteEvent:
		_handle_vignette_event(event.vignette)
	elif event is VignetteEvent:
		_handle_vignette_event(event)
	elif event is CellEvent:
		print("CELL EVENT")
	else:
		PlayerManager.toggle_move_and_rotate(true)
		print("Unknown event type:", typeof(event)) 

func _handle_vignette_event(event : VignetteEvent) -> void:
	Vignette.instance.start_vignette(event.vignette_data)
	Vignette.instance.option_chosen.connect(vignette_event_end)
	event.start_event()

func vignette_event_end(option_chosen : VignetteOptionData) -> void:
	option_chosen.reward.apply_reward()
	end_event()

func _handle_combat_event(event : CombatEvent) -> void:
	if not CombatManager.instance.combat_ended.is_connected(end_event):
		CombatManager.instance.combat_ended.connect(end_event)
	#Start a fight, resolve when it ends
	active_event = event
	CombatManager.instance.start_combat(event.combat_data)

func end_event() -> void:
	PlayerManager.toggle_move_and_rotate(true)
	pass
