extends CanvasLayer

onready var _info_bar: Label = find_node('InfoBar')
onready var _dialog_text: Label = find_node('DialogText')
onready var _game_width: float = get_viewport().get_visible_rect().end.x


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	_info_bar.text = ''
	
	# Conectarse a eventos del universo digimon
	InterfaceEvents.connect('show_info_requested', self, '_update_info_bar')
	InterfaceEvents.connect('character_spoke', self, '_show_dialog_text')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _update_info_bar(info := '') -> void:
	_info_bar.text = info


func _show_dialog_text(chr: Character, msg := '') -> void:
	_dialog_text.text = msg
	_dialog_text.self_modulate = chr.text_color
	_dialog_text.rect_position = Utils.get_screen_coords_for(chr)

	yield(get_tree(), 'idle_frame')

	# Ajustar la posición en X del texto que dice el personaje
	_dialog_text.rect_position.x -= _dialog_text.rect_size.x / 2
	if _dialog_text.rect_position.x < 0.0:
		_dialog_text.rect_position.x = 4.0
	elif _dialog_text.rect_position.x + _dialog_text.rect_size.x > _game_width:
		_dialog_text.rect_position.x = _game_width - _dialog_text.rect_size.x - 4.0
	
	# Ajustar la posición en Y del texto que dice el personaje	
	_dialog_text.rect_position.y -= _dialog_text.rect_size.y
	_dialog_text.rect_position.y += chr.sprite.offset.y
	_dialog_text.rect_position.y -= 10.0
