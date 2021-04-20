tool
extends "res://src/Nodes/Hotspot/Hotspot.gd"

func on_interact() -> void:
	I.emit_signal('show_inline_dialog', ['A esto le falta mucho', '...vamos a terminarlo'])


func on_look() -> void:
	._on_look()
