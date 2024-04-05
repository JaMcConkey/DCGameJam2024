extends PanelContainer

var dragging = false
var offset : Vector2
var control_to_move : Control
#func _physics_process(delta):
	#if dragging:
		#global_position = get_global_mouse_position()
func _ready():
	control_to_move = get_parent()

#func _unhandled_input(event):
	#if event is InputEventMouseButton and event.is_pressed():
		#match event.button_index:
			#MOUSE_BUTTON_LEFT:
				#dragging = true
	#dragging = false

func _on_gui_input(event):
		if event is InputEventMouseButton:
			print("IS MOUSE EVENT")
			if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
				# Check if mouse is pressed within the Control node
				print("EVENT ON")
				if control_to_move.get_rect().has_point(get_global_mouse_position()):
					dragging = true
					offset = get_global_mouse_position() - control_to_move.global_position
					# Calculate offset from mouse position to the top-left corner of the Control node
					print("SHOULD BE DRAGGING HERE")
					return true
			elif event.button_index == MOUSE_BUTTON_LEFT and dragging and not event.pressed:
				# Stop dragging when the left mouse button is released
				dragging = false
				return true
		elif event is InputEventMouseMotion and dragging:
			# Move the Control node based on mouse movement
			control_to_move.global_position = get_global_mouse_position() - offset
			return true
