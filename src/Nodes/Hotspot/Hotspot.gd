tool
class_name Hotspot
extends Area2D

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
	connect('input_event', self, '_check_input_type')
	connect('mouse_entered', self, '_toggle_description', [true])
	connect('mouse_exited', self, '_toggle_description', [false])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_input_type(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_event: = event as InputEventMouseButton 
	if mouse_event and mouse_event.pressed:
		if mouse_event.button_index == BUTTON_LEFT:
			# TODO: Verificar si hay un elemento de inventario seleccionado
			_on_interact()
		elif mouse_event.button_index == BUTTON_RIGHT:
			_on_look()


func _on_interact() -> void:
	prints('Interactuar con:', description)
	emit_signal('interacted')


func _on_look() -> void:
	prints('Observar:', description)
	emit_signal('looked')


func _on_use_inventory_item() -> void:
	pass


func _toggle_description(display: bool) -> void:
	InterfaceEvents.emit_signal('show_info_requested', description if display else '')
