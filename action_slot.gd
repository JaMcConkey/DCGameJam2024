extends Control
@onready var action_name = $Panel/ActionName

var bound_action : PlayerAction
@onready var off_cost = $HBoxContainer/OffCost
@onready var def_cost = $HBoxContainer/DefCost
@onready var cd = $HBoxContainer/CD
@onready var cd_left = $HBoxContainer/CDLeft
var action_controller : PlayerActionManager

func bind_action(action : PlayerAction):
	action_controller = PlayerManager.player.player_action_manager
	action_controller.action_points_updated.connect(update_slot)
	bound_action = action
	update_slot(action_controller)
	bound_action.action_updated.connect(update_slot)
	pass
	
func update_slot(manager : PlayerActionManager):
	if bound_action == null:
		queue_free()
		return
	if not manager.can_use_action(bound_action):
		modulate = Color.RED
	else:
		modulate = Color.WHITE
	action_name.text = bound_action.action_name
	off_cost.text = str(bound_action.offensive_point_cost)
	def_cost.text = str(bound_action.defensive_point_cost)
	cd.text = str(bound_action.cooldown)
	cd_left.text = str(bound_action.remaining_cd)
	pass
func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		if action_controller.can_use_action(bound_action):
			action_controller.use_action(bound_action)
		else:
			print("COULDNT USE ACTION")
			

