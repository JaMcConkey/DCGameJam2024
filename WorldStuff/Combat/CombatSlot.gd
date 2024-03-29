class_name CombatSlot
extends Control

@export var highlight_panel : Panel
@export var show_effected_panel : Panel
@export var monster_picture : TextureRect
@export var health_bar : ProgressBar
@export var health_label : Label
@export var name_label : RichTextLabel
@export var monster_info_main : Control
@export var anim : AnimatedSprite2D

@onready var mag_armor = $MonsterInfo/HealthBar/MagArmor
@onready var mag_amount = $MonsterInfo/HealthBar/MagArmor/MagAmount

@onready var phy_armor = $MonsterInfo/HealthBar/PhyArmor
@onready var phy_amount = $MonsterInfo/HealthBar/PhyArmor/PhyAmount

var pos : Vector2i
var monster : Enemy# Will be for the monster - Going to static type later

signal on_mouse_over(CombatSlot)
signal on_mouse_leave(CombatSlot)
func initialize_slot(pos : Vector2i):
	self.pos = pos
#NOTE: WIll static type these functions later
func assign_monster(enemy : Enemy):
	#If we already had a monster here, make sure we disconnect from it's updates
	if monster !=null:
		monster.enemy_updated.disconnect(update_slot_ui)
		monster.enemy_killed.disconnect(remove_monster)
	if enemy != null:
		enemy.enemy_updated.connect(update_slot_ui)
		enemy.enemy_killed.connect(remove_monster)
	monster = enemy
	update_slot_ui(enemy)

func remove_monster(enemy_to_remove : Enemy):
	if monster == null:
		return
	monster = null


func update_slot_ui(enemy : Enemy):
	#If we assign null let's hide
	if monster == null:
		monster_info_main.hide()
		return
	monster_info_main.show()
	monster_picture.texture = monster.enemy_image
	health_bar.max_value = monster.max_health
	health_bar.value = monster.current_health
	health_label.text = str(monster.current_health) + " / " + str(monster.max_health)
	update_armor_ui()


func toggle_highlight(show : bool):
	highlight_panel.visible = show
func toggle_effected(show : bool):
	show_effected_panel.visible = show

#NOTE: This feels silly, but good enough for now
#NOTE: ALL CHILDREN MUST HAVE MOUSE SET TO IGNORE
func emit_mouse_over():
	on_mouse_over.emit(self)
func emit_mouse_leave():
	on_mouse_leave.emit(self)
func _on_mouse_entered():
	emit_mouse_over()
func _on_mouse_exited():
	emit_mouse_leave()

signal anim_done
func play_anim(sprite_frames : SpriteFrames):
	anim.sprite_frames = sprite_frames
	anim.play("effect")

#Finished wasn't working, so just stopping it on the loop
func _on_anim_sprite_animation_looped():
	anim.stop()
	anim.sprite_frames = null
	anim_done.emit()

func update_armor_ui():
	if monster == null:
		mag_armor.hide()
		phy_armor.hide()
	else:
		mag_amount = monster.magic_armor
		phy_amount = monster.physical_armor
