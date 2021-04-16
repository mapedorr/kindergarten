extends 'res://src/Nodes/Prop/Prop.gd'

var _interacted := false

func _ready():
	._ready()
	
	WorldEvents.connect('character_move_ended', self, '_on_character_move_ended')


func on_interact() -> void:
	_interacted = true
	._on_interact()


func on_look() -> void:
	._on_look()


func _on_character_move_ended(character: Character) -> void:
	if _interacted:
		WorldEvents.emit_signal('character_spoke', character, 'Uy, un balde re-áspero')
		yield(get_tree().create_timer(1.0), 'timeout')
		Inventory.add_item('Bucket')
		get_parent().remove_child(self)
		queue_free()
