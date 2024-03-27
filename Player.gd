extends Node
class_name Player
signal toggle_inventory

@export var inventory_data : InventoryData
@export var equip_inventory_data : Array[EquipInventoryData]
@onready var sanity_manager = $SanityManager
@onready var player_action_manager = $PlayerActionManager

func _ready():
	PlayerManager.player = self




func _unhandled_input(event):
	if event.is_action_pressed("ToggleInventory"):
		toggle_inventory.emit()

func damage(amount : int) -> void:
	pass
func heal(amount: int ) -> void:
	pass
func learn_action(player_action : PlayerAction):
	player_action_manager.add_action(player_action)
