tool
extends 'res://src/Nodes/Prop/Prop.gd'


func on_interact() -> void:
	yield(C.walk_to_clicked(), 'completed')
	# TODO: Hacer que la línea del berrinche la diga otro personaje
	yield(C.player_say('Esa mierda huele a berrinche como un hijueputa'), 'completed')
	I.emit_signal('show_inline_dialog', ['Hola', 'Carita', 'de bola'])
	I.done()


func on_look() -> void:
	._on_look('Qué pozo más rico...')
