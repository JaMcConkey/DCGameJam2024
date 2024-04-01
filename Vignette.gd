extends PanelContainer
class_name Vignette

signal option_chosen(option_chosen : VignetteOptionData)
const VIGNETTE_OPTION = preload("res://WorldStuff/Cells/Events/Vignette/vignette_option.tscn")
@export var option_scene : PackedScene
@onready var option_holder = $Panel/option_holder

var option_array : Array[VignetteOption]
var vignette_data : VignetteData
static var instance : Vignette

func _ready():
	instance = self

func start_vignette(data : VignetteData):
	for option in option_array:
		option.queue_free()
	option_array.clear()
	for option in data.options:
		var choice : VignetteOption 
		choice = VIGNETTE_OPTION.instantiate()
		choice.init_option(option)
		choice.chosen.connect(end_vignette)
		option_array.append(choice)
		option_holder.add_child(choice)
	show()

func end_vignette(chosen_option : VignetteOption):
	#Make sure to emit the DATA of the hchosen option
	option_chosen.emit(chosen_option.data)
	hide()
