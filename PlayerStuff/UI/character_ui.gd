extends Panel
class_name CharacterUI

@onready var bravery_value = $Stats/MainStats/BraveryLabel/BraveryText/BraveryValue
@onready var react_value = $Stats/MainStats/ReactionLabel/ReactionText/ReactValue
@onready var will_value = $Stats/MainStats/WillPowerLabel/WillpowerText/WillValue
@onready var phys_pow_value = $Stats/MainStats/PhysPower/Panel/PhysPowValue
@onready var mag_pow_value = $Stats/MainStats/MagPower/Panel2/MagPowValue
@onready var health_bar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_player_ui():
	PlayerManager.player.stats.PlayerStatsUpdated.connect(update_stats)
	PlayerManager.player.player_action_manager.action_points_updated.connect(update_ap)
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
	$Actions/Label/Value.text = str(player_am.total_off_ap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
