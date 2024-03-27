extends Resource
class_name Enemy

signal enemy_updated(enemy: Enemy)

@export var enemy_name : String
@export var enemy_image : Texture

@export var max_health : float
var current_health : float
var physical_armor : float
var magic_armor : float

func init_enemy():
	current_health = max_health

func take_health_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		enemy_updated.emit(self)

func take_physical_damage(amount: int) -> void:
	# Reduce armor by damage amount
	physical_armor -= amount
	# If armor goes below 0, apply the remaining damage to health
	if physical_armor < 0:
		take_health_damage(-physical_armor)
		physical_armor = 0
	enemy_updated.emit(self)

func take_magic_damage(amount: int) -> void:
	# Reduce armor by damage amount
	magic_armor -= amount
	if magic_armor < 0:
		take_health_damage(-magic_armor)
		magic_armor = 0
		enemy_updated.emit(self)
