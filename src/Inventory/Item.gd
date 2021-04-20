extends Control
class_name Item
# Estos son los objetos que podrán ir al inventario:
# InterfaceLayer > InventoryContainer > ... > InventoryGrid

export var description := ''
export var stack := false
export var script_name := ''
export(Cursor.Type) var cursor

var amount = 1


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	connect('mouse_entered', self, '_toggle_description', [true])
	connect('mouse_exited', self, '_toggle_description', [false])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
# Cuando se le hace clic en el inventario
func on_interact() -> void:
	prints('aaaaaaaaaaaaaa')


# Lo que pasará cuando se haga clic derecho en el icono del inventario
func on_look() -> void:
	pass


# Lo que pasará cuando se use otro Item del inventario sobre este
func on_use_item() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _toggle_description(display: bool) -> void:
	Cursor.set_cursor(cursor if display else null)
	I.emit_signal('show_info_requested', description if display else '')
