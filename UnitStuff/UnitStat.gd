extends Resource
class_name UnitStat

signal StatUpdated(stat: UnitStat)

@export var value_name: String = ""
@export var base_value: int
var _modifiers: Dictionary = {}
var _cached_value: int = 0
var _is_dirty: bool = true # Initialize as dirty to ensure the first calculation

func _init():
	_modifiers = {}

var value: int:
	get:
		if _is_dirty: # Check if the value is dirty
			_cached_value = get_value() # Recalculate and cache the value
			_is_dirty = false # Mark the value as clean
		return _cached_value
	set(value):
		pass

func get_value() -> int:
	var to_return = base_value
	for mods in _modifiers.values():
		for mod in mods:
			to_return += mod.add_amount
			if mod.multiplier > 0:
				to_return *= mod.multiplier
	return to_return

# Add modifier to the stat
func add_modifier(modifier: StatModifier, source = null, stackable_source = false):
	if source == null:
		source = "default"
	if not _modifiers.has(source):
		_modifiers[source] = []
	if not stackable_source:
		_modifiers[source].clear() # Clear existing modifiers if source is not stackable
	_modifiers[source].append(modifier)
	_is_dirty = true # Mark the value as dirty
	emit_signal("StatUpdated", self)

# Remove modifier from the stat
func remove_modifier(modifier: StatModifier, source = null):
	if source == null:
		source = "default"
	if _modifiers.has(source):
		_modifiers[source].erase(modifier)
		if _modifiers[source].empty():
			_modifiers.erase(source)
		_is_dirty = true # Mark the value as dirty
		emit_signal("StatUpdated", self)

# Remove all modifiers associated with a specific source
func remove_modifiers_from_source(source):
	if _modifiers.has(source):
		_modifiers.erase(source)
		_is_dirty = true # Mark the value as dirty
		emit_signal("StatUpdated", self)
