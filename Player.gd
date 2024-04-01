extends Node
class_name Player
signal toggle_inventory

@export var inventory_data : InventoryData
@export var equip_inventory_data : Array[EquipInventoryData]
@onready var sanity_manager = $SanityManager
@onready var player_action_manager : PlayerActionManager = $PlayerActionManager
@onready var stats : PlayerStats = $PlayerStats

func _ready():
	PlayerManager.player = self
	InventoryInterface.instance.init_player_inventory()
	stats.init_player_stats()
	player_action_manager.init_action_manager()
	$"../UI/CharacterUI".init_player_ui()

func take_damage(damage : Damage):
	stats.take_damage(damage)
	pass


var count = 0
func _unhandled_input(event):
	if event.is_action_pressed("ToggleInventory"):
		var text = "ADDED AN EVENT " + str(count)
		EventLog.add_event_log(text)
		count += 1
		toggle_inventory.emit()

func damage(amount : int) -> void:
	pass
func heal(amount: int ) -> void:
	pass
func learn_action(player_action : PlayerAction):
	player_action_manager.add_action(player_action)

