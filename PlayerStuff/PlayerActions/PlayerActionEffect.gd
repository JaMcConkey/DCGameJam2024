extends Resource
class_name PlayerActionEffect

signal effect_resolved

@export var animation : PackedScene
@export var anim_sprites : SpriteFrames
@export var test_vfx_effect : PackedScene
func apply_to_slot(slot : CombatSlot) -> void:
	pass

func play_vfx(slot : CombatSlot):
		if test_vfx_effect:
			var effect = test_vfx_effect.instantiate()
			if effect is EffectVFX:
				var rect_pos = slot.monster_picture.position
				var rect_size = slot.monster_picture.size
				var effect_pos = rect_pos + rect_size /2
				effect.global_position = effect_pos
				slot.add_child(effect)
				await effect.vfx_done

func effect_done() -> void:
	effect_resolved.emit()
