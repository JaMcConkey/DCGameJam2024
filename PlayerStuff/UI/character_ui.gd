extends Control
class_name CharacterUI
const ACTION_SLOT = preload("res://action_slot.tscn")
@onready var bravery_value = $Stats/MainStats/BraveryLabel/BraveryText/BraveryValue
@onready var react_value = $Stats/MainStats/ReactionLabel/ReactionText/ReactValue
@onready var will_value = $Stats/MainStats/WillPowerLabel/WillpowerText/WillValue
@onready var phys_pow_value = $Stats/MainStats/PhysPower/Panel/PhysPowValue
@onready var mag_pow_value = $Stats/MainStats/MagPower/Panel2/MagPowValue
@onready var health_bar = $HealthBar
@onready var action_holder = $Actions/ActionHolder

@export var phys_ico : TextureRect
@export var def_ico : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_player_ui():
	PlayerManager.player.stats.PlayerStatsUpdated.connect(update_stats)
	PlayerManager.player.player_action_manager.action_points_updated.connect(update_ap)
	PlayerManager.player.player_action_manager.actions_updated.connect(update_action_slots)
	update_stats(PlayerManager.player.stats)
func update_stats(stats : PlayerStats) -> void:
	bravery_value.text = str(stats.bravery.value)
	react_value.text = str(stats.reaction.value)
	will_value.text = str(stats.willpower.value)
	phys_pow_value.text = str(stats.physical_power.value)
	mag_pow_value.text = str(stats.magical_power.value)
	health_bar.max_value = stats.max_health.value
	health_bar.value = stats.current_health
	pass
func update_ui() -> void:
	pass

func update_ap(player_am : PlayerActionManager):
	for child in $Actions/PhysActions.get_children():
		child.queue_free()
	for child in $Actions/DefActions.get_children():
		child.queue_free()
	for phys in player_am.cur_off:
		var ico = phys_ico.duplicate()
		$Actions/PhysActions.add_child(ico)
		ico.show()
	for def in player_am.cur_def:
		var ico = def_ico.duplicate()
		$Actions/DefActions.add_child(ico)
		ico.show()

func update_action_slots(action_manager : PlayerActionManager):
	for child in action_holder.get_children():
		child.queue_free()
	for action in action_manager.known_actions:
		var slot = ACTION_SLOT.instantiate()
		action_holder.add_child(slot)
		slot.bind_action(action)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
