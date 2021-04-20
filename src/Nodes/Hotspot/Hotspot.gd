tool
class_name Hotspot
extends Area2D
# Permite crear áreas con las que se puede interactuar.
# Ej: El cielo, algo que haga parte de la imagen de fondo.

signal interacted
signal looked

export var description := ''
export var baseline := 0
export var clickable := true
export var walk_to_point: Vector2
export var look_at_point: Vector2
export(Cursor.Type) var cursor
export var script_name := ''


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	connect('mouse_entered', self, '_toggle_description', [true])
	connect('mouse_exited', self, '_toggle_description', [false])
	
	set_process_unhandled_input(false)


func _unhandled_input(event):
	var mouse_event: = event as InputEventMouseButton 
	if mouse_event and mouse_event.pressed:
		if event.is_action_pressed('interact'):
			# TODO: Verificar si hay un elemento de inventario seleccionado
			get_tree().set_input_as_handled()
			on_interact()
		elif event.is_action_pressed('look'):
			on_look()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func on_interact() -> void:
	pass


func on_look() -> void:
	pass



# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _on_interact() -> void:
	emit_signal('interacted')


func _on_look() -> void:
	emit_signal('looked')


func _on_use_inventory_item() -> void:
	pass


func _toggle_description(display: bool) -> void:
	set_process_unhandled_input(display)
	Cursor.set_cursor(cursor if display else null)
	I.emit_signal('show_info_requested', description if display else '')
