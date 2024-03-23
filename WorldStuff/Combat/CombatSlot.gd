class_name CombatSlot
extends Control

@export var highlight_panel : Panel
@export var show_effected_panel : Panel
@export var monster_picture : TextureRect

var pos : Vector2i
var monster # Will be for the monster - Going to static type later

signal on_mouse_over(CombatSlot)
signal on_mouse_leave(CombatSlot)
func initialize_slot(pos : Vector2i):
	self.pos = pos
#NOTE: WIll static type these functions later
func assign_monster(monster):
	pass
func apply_attack(attack):
	pass

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
