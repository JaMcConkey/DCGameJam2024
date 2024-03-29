extends Camera3D
class_name PlayerPawn

signal entered_new_cell(cell : Cell)

@export var turn_time : float = .2
@export var move_time : float = .2
var moving = false
var move_distance = 1
var tween
var can_move : bool = true
var can_rotate : bool = true

@export var raycast : RayCast3D

func _ready():
	PlayerManager.player_pawn = self


func move_forward():
	#If we are moving or raycast is not colliding (Can't see into next tile) bail
	if moving or not raycast.is_colliding():
		return
	
	moving = true
	tween = get_tree().create_tween()
	# calculate the forward vector based on the current rotation
	var forward = -global_transform.basis.z.normalized()
	# get distance needed to move
	var offset = forward * move_distance + position
	tween.tween_property(self,"position",offset,move_time)
	await tween.finished
	moving = false
	#We'll call the world to say we entered the cell
	var new_cell = World.instance.get_cell_at_position(global_position)
	World.instance.place_player_in_cell(new_cell)

func turn_left():
	tween_rotation(90)
func turn_right():
	tween_rotation(-90)

# This will cause problems later, as Rotation does not stop at 360. So we can
#go up forever right now
func tween_rotation(degrees):
	if moving:
		return
	moving = true
	tween = get_tree().create_tween()
	var current_rotation = rotation_degrees.y
	var target_rotation = current_rotation + degrees
	tween.tween_property(self, "rotation_degrees:y", target_rotation, turn_time)
	await tween.finished
	moving = false
#
#func emit_cell_entered(cell : Cell):
	#entered_new_cell.emit(cell)
#
#func _on_player_hit_box_area_entered(area):
	#if area is Cell:
		#emit_cell_entered(area)
