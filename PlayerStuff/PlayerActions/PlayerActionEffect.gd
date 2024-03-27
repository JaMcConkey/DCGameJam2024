extends Resource
class_name PlayerActionEffect

signal effect_resolved

@export var animation : PackedScene
@export var anim_sprites : SpriteFrames
func apply_to_slot(slot : CombatSlot) -> void:
	effect_resolved.emit()
