extends PanelContainer

@onready var event_text = $EventText


# Called when the node enters the scene tree for the first time.
func _ready():
	EventLog.event_added.connect(add_text)
	pass # Replace with function body.

func add_text(string : String) -> void:
	event_text.text += string


# Called every frame. 'delta' 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
