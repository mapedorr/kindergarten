extends CanvasLayer

var _can_hide_inventory := true
var _is_inventory_hidden := false

onready var _info_bar: Label = find_node('InfoBar')
onready var _dialog_text: AnimatedRichText = find_node('DialogText')
onready var _display_box: Label = find_node('DisplayBox')
onready var _inventory: NinePatchRect = find_node('InventoryContainer')
onready var _inventory_hide_y := _inventory.rect_position.y - (_inventory.rect_size.y - 3.5)
onready var _inventory_foreground: TextureRect = find_node('InventoryForeground')
onready var _inventory_grid: GridContainer = find_node('InventoryGrid')
onready var _click_handler: Button = $MainContainer/ClickHandler


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	_info_bar.text = ''

	_display_box.text = ''
	_display_box.hide()
	
	_inventory.rect_position.y = _inventory_hide_y
	_inventory.rect_size.x = _inventory_foreground.rect_size.x
	
	for i in _inventory_grid.get_children():
		(i as TextureRect).connect('mouse_entered', self, '_show_item_info', [true])
		(i as TextureRect).connect('mouse_exited', self, '_show_item_info', [false])
	
	# --------------------------------------------------------------------------
	# Conectarse a eventos de los hijos
	# TODO: Algunos de estos realmente irán en el script de cada hijo
	_inventory.connect('mouse_entered', self, '_toggle_inventory', [true])
	_inventory.connect('mouse_exited', self, '_toggle_inventory', [false])
	_inventory.connect('item_added', self, '_tmp')
	_click_handler.connect('pressed', self, '_continue')
	
	# Conectarse a eventos del universo digimon
	C.connect('character_spoke', self, '_show_dialog_text')
#	C.connect('character_moved', self, '_hide_interface_elements')
	I.connect('show_info_requested', self, '_update_info_bar')
	I.connect('show_box_requested', self, '_show_display_box')
	I.connect('freed', self, '_toggle_panels', [true])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _update_info_bar(info := '') -> void:
	_info_bar.text = info


func _show_display_box(msg := '') -> void:
	_display_box.text = msg
	if msg:
		_toggle_panels(false)
		_display_box.show()
	else:
		_toggle_panels(true)
		_display_box.hide()


func _show_dialog_text(chr: Character, msg := '') -> void:
	_toggle_panels(false)
	_dialog_text.play_text({
		text = msg,
		color = chr.text_color,
		position = Utils.get_screen_coords_for(chr),
		offset_y = chr.sprite.position.y
	})


func _hide_interface_elements(chr: Character) -> void:
	# TODO: Afectar sólo al nodo que corresponda al personaje recibido
	_dialog_text.stop()
	_show_display_box()


func _toggle_inventory(appear: bool) -> void:
	if appear:
		if _inventory.rect_position.y != _inventory_hide_y: return
		$Tween.interpolate_property(
			_inventory, 'rect_position:y',
			_inventory_hide_y, 0.0,
			0.5, Tween.TRANS_EXPO, Tween.EASE_OUT
		)
	else:
		yield(get_tree(), 'idle_frame')
		if not _can_hide_inventory: return
		$Tween.interpolate_property(
			_inventory, 'rect_position:y',
			0.0, _inventory_hide_y,
			0.2, Tween.TRANS_SINE, Tween.EASE_IN
		)
	$Tween.start()


func _show_item_info(appear: bool) -> void:
	_can_hide_inventory = false if appear else true
	_update_info_bar('Balde' if appear else '')


func _tmp(item: Item) -> void:
	(item as Control).connect('mouse_entered', self, '_show_item_info', [true])
	(item as Control).connect('mouse_exited', self, '_show_item_info', [false])
	_toggle_inventory(true)
	yield(get_tree().create_timer(2.0), 'timeout')
	_toggle_inventory(false)


func _toggle_panels(appear: bool) -> void:
	# TODO: Usar Tween para que se oculte y aparezca con jugo

	if _is_inventory_hidden and not appear: return

	if appear:
		_is_inventory_hidden = false
		_click_handler.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Tween.interpolate_property(
			_inventory, 'rect_position:y',
			_inventory_hide_y - 3.5, _inventory_hide_y,
			0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
	else:
		_click_handler.mouse_filter = Control.MOUSE_FILTER_STOP
		_is_inventory_hidden = true
		$Tween.interpolate_property(
			_inventory, 'rect_position:y',
			_inventory_hide_y, _inventory_hide_y - 3.5,
			0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT
		)

	$Tween.start()


func _continue() -> void:
	_info_bar.hide()
	_display_box.hide()
	_dialog_text.stop()
	I.emit_signal('continue_clicked')
