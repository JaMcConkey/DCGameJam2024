extends Resource
class_name EventReward

@export var experience_gain : int
@export var items_gained : Array[ItemData]
@export var player_stats_increase : PlayerStatMod

func apply_reward() -> void:
	PlayerManager.player.stats.apply_stat_modifier(player_stats_increase,self)
	pass
