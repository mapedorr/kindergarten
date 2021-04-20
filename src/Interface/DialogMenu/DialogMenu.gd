class_name DialogMenu
extends Container

var current_options := []

var _option: PackedScene = load('res://src/Interface/DialogMenu/DialogOption.tscn')

onready var _container: Container = find_node('OptionsContainer')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	I.connect('show_inline_dialog', self, '_create_options', [true])
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _create_options(options := [], autoshow := false) -> void:
	remove_options()

	if options.empty():
		if not current_options.empty():
			show_options()
		return

	current_options = options
	for opt in options:
		var btn: Button = _option.instance() as Button

		btn.text = opt
#		btn.connect('pressed', self, '_on_option_clicked', [opt])

		_container.add_child(btn)

#		if opt.has('show') and not opt.show:
#			opt.show = false
#			btn.hide()
#		else:
#			opt.show = true

	if autoshow: show_options()
	
	yield(get_tree(), 'idle_frame')
	prints(_container.rect_size.y, Data.game_height - _container.rect_size.y)
	rect_size.y = _container.rect_size.y
	rect_position.y = Data.game_height - _container.rect_size.y
#
#
func remove_options() -> void:
	if not current_options.empty():
		current_options.clear()

		for btn in _container.get_children():
#			(btn as Button).call_deferred('queue_free')
			_container.remove_child(btn as Button)
#		hide()
	
	rect_size.y = 0
	_container.rect_size.y = 0
#
#
#func update_options(updates_cfg := {}) -> void:
#	if not updates_cfg.empty():
#		var idx := 0
#		for btn in get_children():
#			btn = (btn as Button)
#			var id := String(btn.get_index())
#			if updates_cfg.has(id):
#				if not updates_cfg[id]:
#					current_options[idx].show = false
#					btn.hide()
#				else:
#					current_options[idx].show = true
#					btn.show()
#			if btn.is_in_group('FocusGroup'):
#				btn.remove_from_group('FocusGroup')
#				btn.remove_from_group('DialogMenu')
#				guiBrain.gui_collect_focusgroup()
#			idx+= 1
#
#
func show_options() -> void:
	# Establecer cuál será la primera opción a seleccionar cuando se presione
	# una flecha del teclado

	show()
#
#
#func _on_option_clicked(opt: Dictionary) -> void:
#	SectionEvent.dialog = false
#	hide()
#	DialogEvent.emit_signal('dialog_option_clicked', opt)
