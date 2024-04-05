extends Node
class_name Player
signal toggle_inventory

@export var inventory_data : InventoryData
@export var equip_inventory_data : Array[EquipInventoryData]
@onready var sanity_manager = $SanityManager
@onready var player_action_manager : PlayerActionManager = $PlayerActionManager
@onready var stats : PlayerStats = $PlayerStats

@export var equip_controller : PlayerEquipController

@export var test_learn_action : PlayerAction

func _ready():
	PlayerManager.player = self
	InventoryInterface.instance.init_player_inventory()
	stats.init_player_stats()
	player_action_manager.init_action_manager()
	$"../UI/CharacterUI".init_player_ui()
	#ADD TO WORLD HERE FOR NOW
	#var random_cell = randi() % World.instance.cells.size()
	World.instance.place_player_in_cell(World.instance.get_eventless_cell())

func take_damage(damage : Damage):
	stats.take_damage(damage)
	pass

func damage(amount : int) -> void:
	pass
func heal(amount: int ) -> void:
	pass
func learn_action(player_action : PlayerAction):
	player_action_manager.add_action(player_action)

