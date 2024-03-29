extends Node

signal event_added(text : String)

func add_event_log(text : String):
	var string_to_emit = ""
	string_to_emit += "\n"
	string_to_emit += text
	event_added.emit(string_to_emit)
