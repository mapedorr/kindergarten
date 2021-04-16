tool
class_name Prop
extends Sprite

signal interacted(msg)
signal looked(msg)

export var description := ''
export var baseline := 0 setget _set_baseline
export var clickable := true
export var walk_to_point := Vector2.ZERO setget _set_walk_to_point
export var look_at_point := Vector2.ZERO
export(Cursor.Type) var cursor = Cursor.Type.ACTIVE
export var script_name := ''

onready var _collider: Area2D = $Area2D


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	_collider.connect('input_event', self, '_check_input_type')
	_collider.connect('mouse_entered', self, '_toggle_description', [true])
	_collider.connect('mouse_exited', self, '_toggle_description', [false])
	
	if not Engine.editor_hint:
		remove_child($BaselineHelper)
		remove_child($WalkToHelper)


func _process(delta):
	if Engine.editor_hint:
		if walk_to_point != get_node('WalkToHelper').position:
			# Esto debería ocurrir sólo si se cambiar en el editor la posición
			# del WalkToHelper
			walk_to_point = get_node('WalkToHelper').position
			property_list_changed_notify()
		elif baseline != get_node('BaselineHelper').position.y:
			baseline = get_node('BaselineHelper').position.y
			property_list_changed_notify()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func on_interact() -> void:
	_on_interact()


func on_look() -> void:
	_on_look()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_input_type(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mouse_event: = event as InputEventMouseButton 
	if mouse_event:
		if event.is_action_pressed('interact'):
			# TODO: Verificar si hay un elemento de inventario seleccionado
			on_interact()
		elif event.is_action_pressed('look'):
			on_look()


func _on_interact(msg := '') -> void:
	emit_signal('interacted', msg)


func _on_look(msg := '') -> void:
	emit_signal('looked', msg)


func _on_use_inventory_item(msg := '') -> void:
	pass


func _toggle_description(display: bool) -> void:
	Cursor.set_cursor(cursor if display else null)
	InterfaceEvents.emit_signal('show_info_requested', description if display else '')


func _set_baseline(value: int) -> void:
	baseline = value
	
	if Engine.editor_hint and get_node_or_null('BaselineHelper'):
		get_node('BaselineHelper').position = Vector2.DOWN * value


func _set_walk_to_point(value: Vector2) -> void:
	walk_to_point = value
	
	if Engine.editor_hint and get_node_or_null('WalkToHelper'):
		get_node('WalkToHelper').position = value
