tool
extends 'res://src/Nodes/Hotspot/Hotspot.gd'

func on_interact() -> void:
	C.character_say('Paco', 'Me dan miedo las cuevas')


func on_look() -> void:
	._on_look()
