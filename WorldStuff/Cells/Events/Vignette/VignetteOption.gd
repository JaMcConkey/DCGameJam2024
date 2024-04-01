extends Panel
class_name VignetteOption

signal chosen(option : VignetteOption)

#@onready var button = $Containter/Button
@export var button : Button
@onready var reward_text = $RewardText
var data : VignetteOptionData

func init_option(data_to_init : VignetteOptionData):
	if data_to_init == null:
		print("TRYING TO INIT WITH NULL DATA")
		return
	data = data_to_init
	button.text = data.label_description

func _on_button_pressed():
	chosen.emit(self)
	pass # Replace with function body.
