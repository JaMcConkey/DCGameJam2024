extends Resource
class_name ItemData

@export var item_name : String = ""
@export_multiline var description : String = ""
@export var stackable : bool
@export var image : Texture

func use(target) -> void:
	print("USED ITEM")
	pass
