extends 'res://src/Nodes/Character/Character.gd'

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	I.emit_signal('show_inline_dialog', ['Hola', 'Carita', 'de bola'])


func on_look() -> void:
	yield(I.display('Ese es otro personaje'), 'completed')
	I.done()
