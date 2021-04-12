extends CanvasLayer

onready var _info_bar: Label = find_node('InfoBar')
onready var _dialog_text: AnimatedRichText = find_node('DialogText')
onready var _display_box: Label = find_node('DisplayBox')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
#	add_child(Cursor)
	
	_info_bar.text = ''
	_display_box.text = ''
	_display_box.hide()
	
	# Conectarse a eventos del universo digimon
	WorldEvents.connect('character_spoke', self, '_show_dialog_text')
	WorldEvents.connect('character_moved', self, '_hide_interface_elements')
	InterfaceEvents.connect('show_info_requested', self, '_update_info_bar')
	InterfaceEvents.connect('show_box_requested', self, '_update_display_box')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _update_info_bar(info := '') -> void:
	_info_bar.text = info


func _update_display_box(msg := '') -> void:
	_display_box.text = msg
	if msg: _display_box.show()
	else: _display_box.hide()


func _show_dialog_text(chr: Character, msg := '') -> void:
	_dialog_text.play_text({
		text = msg,
		color = chr.text_color,
		position = Utils.get_screen_coords_for(chr),
		offset_y = chr.sprite.position.y
	})


func _hide_interface_elements(chr: Character) -> void:
	# TODO: Afectar sólo al nodo que corresponda al personaje recibido
	_dialog_text.stop()
	_update_display_box()
