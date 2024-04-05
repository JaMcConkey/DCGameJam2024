extends Resource
class_name Enemy

signal enemy_updated(enemy: Enemy)
signal took_damage(enemy : Enemy)
signal enemy_killed(enemy : Enemy)

@export var enemy_name : String
@export var enemy_image : Texture

@export var max_health : float
@export var enemy_actions : Array[EnemyAction]
var current_health : float
var physical_armor : float
var magic_armor : float

var assigned_slot : CombatSlot

func init_enemy():
	current_health = max_health

func take_damage(damage : Damage) -> void:
	_take_physical_damage(damage.phys_damage)
	_take_magic_damage(damage.mag_damage)
	_take_health_damage(damage.true_damage)
	enemy_updated.emit(self)
	took_damage.emit(self)
	pass

func _take_health_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		enemy_killed.emit(self)
		print("SHOULD BE DEAD")
	else:
		enemy_updated.emit(self)

func _take_physical_damage(amount: int) -> void:
	# Reduce armor by damage amount
	physical_armor -= amount
	# If armor goes below 0, apply the remaining damage to health
	if physical_armor < 0:
		_take_health_damage(-physical_armor)
		physical_armor = 0
	enemy_updated.emit(self)

func _take_magic_damage(amount: int) -> void:
	# Reduce armor by damage amount
	magic_armor -= amount
	if magic_armor < 0:
		_take_health_damage(-magic_armor)
		magic_armor = 0
		enemy_updated.emit(self)
		
func get_enemy_intent() -> void:
	pass
func get_enemy_action() -> EnemyAction:
	return enemy_actions[0]
