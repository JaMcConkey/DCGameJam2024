extends Node
class_name PlayerStats

signal PlayerStatsUpdated(stats : PlayerStats)
#
#@export var max_health : UnitResource
#@export var max_sanity : UnitResource
#
#@export var max_offensive_action_points : UnitResource
#@export var max_defensive_action_points : UnitResource

@export var max_health : int
var current_health : int

var physical_armor : int
var magic_armor : int

@export var strength : UnitStat

func init_player_stats():
	current_health = max_health

func take_damage(damage : Damage) -> void:
	_take_physical_damage(damage.phys_damage)
	_take_magic_damage(damage.mag_damage)
	_take_health_damage(damage.true_damage)
	pass

func _take_health_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		PlayerStatsUpdated.emit(self)

func _take_physical_damage(amount: int) -> void:
	# Reduce armor by damage amount
	physical_armor -= amount
	# If armor goes below 0, apply the remaining damage to health
	if physical_armor < 0:
		_take_health_damage(-physical_armor)
		physical_armor = 0
	PlayerStatsUpdated.emit(self)

func _take_magic_damage(amount: int) -> void:
	# Reduce armor by damage amount
	magic_armor -= amount
	if magic_armor < 0:
		_take_health_damage(-magic_armor)
		magic_armor = 0
		PlayerStatsUpdated.emit(self)
