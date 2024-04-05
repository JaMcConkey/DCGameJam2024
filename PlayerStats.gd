extends Node
class_name PlayerStats

signal PlayerStatsUpdated(stats : PlayerStats)


@export var bravery : UnitStat 
@export var reaction : UnitStat 
@export var willpower : UnitStat
@export var max_health : UnitStat
@export var phys_armor_per_turn : UnitStat
@export var mag_armor_per_turn : UnitStat
@export var physical_power : UnitStat 
@export var magical_power : UnitStat 
var current_health : int

var physical_armor : int 
var magic_armor : int




func init_player_stats():
	current_health = max_health.value
	#NOTE: For not connecting here to inventroy, CHANGE LATER
	for equip_slot in PlayerManager.player.equip_controller.get_all_slot_invs():
		equip_slot.inventory_updated.connect(update_equip_stats)
	#for equip_slot in PlayerManager.player.equip_inventory_data:
		#equip_slot.inventory_updated.connect(update_equip_stats)

func update_equip_stats(inventory : EquipInventoryData):
	var brave_mod : int
	var reaction_mod : int
	var willpower_mod : int
	#Going to ignore this and just update player directly
	remove_modifiers_from_source(inventory)
	for item in inventory.slot_datas:
		#REMOVE OLD MODS

		#If the slot is empty, skip it
		if not item or not item.item_data:
			continue
		var equip_item : EquipItemData
		#Just a failsafe
		if not item.item_data is EquipItemData:
			print("For some reason this wasn't equip data - CHECK WHY")
			continue
		else:
			equip_item = item.item_data
			#Make the slot the source
			apply_stat_modifier(equip_item.stat_modifier,inventory)
	#for item in PlayerManager.player.equip_inventory_data:
		##REMOVE OLD MODS
		#for equip in item.slot_datas:
			#remove_modifiers_from_source(item)
			##If the slot is empty, skip it
			#if not equip or not equip.item_data:
				#continue
			#var equip_item : EquipItemData
			##Just a failsafe
			#if not equip.item_data is EquipItemData:
				#print("For some reason this wasn't equip data - CHECK WHY")
				#continue
			#else:
				#equip_item = equip.item_data
				##Make the slot the source
				#apply_stat_modifier(equip_item.stat_modifier,item)
	PlayerStatsUpdated.emit(self)

func take_damage(damage : Damage) -> void:
	_take_physical_damage(damage.phys_damage)
	_take_magic_damage(damage.mag_damage)
	_take_health_damage(damage.true_damage)
	#NOTE: THis is a heavy call right now for hte UI
	PlayerStatsUpdated.emit(self)
	pass

func _take_health_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		#PlayerStatsUpdated.emit(self)

func _take_physical_damage(amount: int) -> void:
	# Reduce armor by damage amount
	physical_armor -= amount
	# If armor goes below 0, apply the remaining damage to health
	if physical_armor < 0:
		_take_health_damage(-physical_armor)
		physical_armor = 0
	#PlayerStatsUpdated.emit(self)

func _take_magic_damage(amount: int) -> void:
	# Reduce armor by damage amount
	magic_armor -= amount
	if magic_armor < 0:
		_take_health_damage(-magic_armor)
		magic_armor = 0
	#	PlayerStatsUpdated.emit(self)

#NOTE: MESSY SPAGET FIX LATER
func apply_stat_modifier(player_stat_mod : PlayerStatMod, source = null):
	if player_stat_mod == null:
		print("TRIED TO APPLY A NULL PLAYER STAT MOD")
		return
	if player_stat_mod.bravery_mod != null:
		bravery.add_modifier(player_stat_mod.bravery_mod, source)
	if player_stat_mod.reaction_mod != null:
		reaction.add_modifier(player_stat_mod.reaction_mod, source)
	if player_stat_mod.willpower_mod != null:
		willpower.add_modifier(player_stat_mod.willpower_mod, source)
	if player_stat_mod.max_hp_mod != null:
		max_health.add_modifier(player_stat_mod.max_hp_mod, source)
	if player_stat_mod.phys_armor_per_turn_mod != null:
		phys_armor_per_turn.add_modifier(player_stat_mod.phys_armor_per_turn_mod, source)
	if player_stat_mod.physical_power_mod != null:
		physical_power.add_modifier(player_stat_mod.physical_power_mod, source)
	if player_stat_mod.magical_power_mod != null:
		magical_power.add_modifier(player_stat_mod.magical_power_mod, source)

#NOTE: For now using reflection to get all stats, should be fine for what we're doing
func remove_modifiers_from_source(source):
	var properties = get_property_list()
	for property in properties:
		if property.type == TYPE_OBJECT and property.class_name == "UnitStat":
			var stat = get(property.name)
			if stat != null:
				stat.remove_modifiers_from_source(source)
