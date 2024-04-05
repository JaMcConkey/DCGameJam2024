extends AnimatedSprite2D
class_name EffectVFX

signal vfx_done
@export var expire_timer : float = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	play("effect")


func _on_animation_looped():
	stop()
	vfx_done.emit()
	queue_free()

