tool
extends 'res://src/Nodes/Prop/Prop.gd'

var _interacted := false


func on_interact() -> void:
	yield(C.walk_to_clicked(), 'completed')
	C.player_say('Uy, un balde re-áspero')
	yield(get_tree().create_timer(1.0), 'timeout')
	get_parent().remove_child(self)
	queue_free()
	Inventory.add_item('Bucket')


func on_look() -> void:
	._on_look()
