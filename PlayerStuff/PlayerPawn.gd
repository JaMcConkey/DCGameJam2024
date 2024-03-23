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

func toggle_move_and_rotate(toggle : bool):
	can_move = toggle
	can_rotate = toggle

func _input(event):
	if can_rotate:
		if event.is_action_pressed("TurnLeft"):
			turn_left()
		if event.is_action_pressed("TurnRight"):
			turn_right()
	if can_move:
		if event.is_action_pressed("Forward"):
			if raycast.is_colliding():
				move_forward()
				return
func move_forward():
	if moving:
		return
	moving = true
	var tween = get_tree().create_tween()
	# calculate the forward vector based on the current rotation
	var forward = -global_transform.basis.z.normalized()
	# get distance needed to move
	var offset = forward * move_distance + position
	tween.tween_property(self,"position",offset,move_time)
	await tween.finished
	moving = false

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
	var tween = get_tree().create_tween()
	var current_rotation = rotation_degrees.y
	var target_rotation = current_rotation + degrees
	tween.tween_property(self, "rotation_degrees:y", target_rotation, turn_time)
	await tween.finished
	moving = false

func emit_cell_entered(cell : Cell):
	entered_new_cell.emit(cell)

func _on_player_hit_box_area_entered(area):
	if area is Cell:
		emit_cell_entered(area)
