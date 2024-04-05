extends Control
class_name InventoryInterface

signal drop_slot_data(slot_data : InventorySlotData)

var grabbed_slot_data : InventorySlotData
var external_inventory_owner 
static var instance : InventoryInterface

@onready var grabbed_slot = $GrabbedSlot
@onready var inventory_interface = $"."
@onready var player_inventory = $PlayerInventory
@onready var external_invntory = $ExternalInvntory
@onready var confirm_drop = $"../ConfirmDrop"



@export var test_external_data : InventoryData
func _ready():
	instance = self

var call_count : int = 0
func init_player_inventory():
	print("CALLED" , call_count)
	call_count += 1
	var player = PlayerManager.player
	if player == null:
		print("NO PLAYER")
		return
	set_player_inventory_data(player.inventory_data)
	$"../EquipInventory".init_equip_inventory()
	for equip_slot in player.equip_inventory_data:
		equip_slot.inventory_interact.connect(on_inventory_interact)
	player.toggle_inventory.connect(toggle_inventory_interface)
	player.inventory_data.inventory_interact.connect(on_inventory_interact)

func set_player_inventory_data(inventory_data : InventoryData) -> void:
	player_inventory.set_inventory_data(inventory_data)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	player_inventory.visible = not player_inventory.visible
	
	if external_inventory_owner:
		set_external_inventory(external_inventory_owner)
	else:
		clear_external_inventory()

func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var data = external_inventory_owner.inventory_data
	
	data.inventory_interact.connect(on_inventory_interact)
	external_invntory.set_inventory_data(data)
	external_invntory.show()

func clear_external_inventory():
	if external_inventory_owner:
		var data = external_inventory_owner.inventory_data	
		data.inventory_interact.disconnect(on_inventory_interact)
		external_invntory.clear_inventory_data(data)
		external_invntory.hide()
		external_inventory_owner = null

func on_inventory_interact(inventory_data : InventoryData,index : int, button : int) -> void:
	match [grabbed_slot_data, button]:
		 #If no data, and MOUSE LEFT
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index) 
		# _ means there is something there
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data,index)
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func _physics_process(delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() and grabbed_slot_data:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				confirm_drop.dialog_text = "Are you sure you want to drop " +\
				grabbed_slot_data.item_data.item_name + " ?"
				confirm_drop.show()



#On confirm, drop
func _on_confirmation_dialog_confirmed():
	drop_slot_data.emit(grabbed_slot_data)
	grabbed_slot_data = null
	update_grabbed_slot()
	confirm_drop.hide()

func _on_confirmation_dialog_canceled():
	confirm_drop.hide()
	pass # Replace with function body.
