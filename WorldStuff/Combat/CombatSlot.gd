class_name CombatSlot
extends Control

@export var highlight_panel : Panel
@export var show_effected_panel : Panel
@export var invalid_panel : TextureRect
@export var monster_picture : TextureRect
@export var health_bar : ProgressBar
@export var health_label : Label
@export var name_label : RichTextLabel
@export var monster_info_main : Control
@export var anim_player : AnimationPlayer

@onready var mag_armor = $MonsterInfo/HealthBar/MagArmor
@onready var mag_amount = $MonsterInfo/HealthBar/MagArmor/MagAmount

@onready var phy_armor = $MonsterInfo/HealthBar/PhyArmor
@onready var phy_amount = $MonsterInfo/HealthBar/PhyArmor/PhyAmount

var pos : Vector2i
var monster : Enemy

signal anim_done
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
		monster.took_damage.disconnect(flash_hit)
		monster.assigned_slot = null
	if enemy != null:
		enemy.enemy_updated.connect(update_slot_ui)
		enemy.enemy_killed.connect(remove_monster)
		enemy.took_damage.connect(flash_hit)
		enemy.assigned_slot = self
	monster = enemy
	update_slot_ui(enemy)

func flash_hit(enemy_hit : Enemy):
	anim_player.play("get_hit")
func play_attack_anim():
	anim_player.play("attack")

func remove_monster(enemy_to_remove : Enemy):
	if monster == null:
		return
	monster.enemy_updated.disconnect(update_slot_ui)
	monster.enemy_killed.disconnect(remove_monster)
	monster.took_damage.disconnect(flash_hit)
	monster.assigned_slot = null
	monster = null
	update_slot_ui(null)


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
func toggle_invalid(show : bool):
	invalid_panel.visible = show

#NOTE: This feels silly, but good enough for now
#NOTE: ALL CHILDREN MUST HAVE MOUSE SET TO IGNORE
func emit_mouse_over():
	on_mouse_over.emit(self)
func emit_mouse_leave():
	on_mouse_leave.emit(self)

func update_armor_ui():
	if monster == null:
		mag_armor.hide()
		phy_armor.hide()
	else:
		mag_amount = monster.magic_armor
		phy_amount = monster.physical_armor


func _on_hover_area_mouse_entered():
	emit_mouse_over()

func _on_hover_area_mouse_exited():
	emit_mouse_leave()
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	anim_done.emit()
	pass # Replace with function body.
