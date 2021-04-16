extends Control

signal item_added(item)

onready var _grid: GridContainer = $InventoryPanel/InventoryGrid

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	Inventory.connect('item_added', self, '_add_item')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _add_item(item: Item) -> void:
	_grid.add_child(item)
	emit_signal('item_added', item)
