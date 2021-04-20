extends Node2D

var path := []

var _nav_path: Navigation2D

onready var character: Character = find_node('Dave')
onready var room: Room = find_node('Room')
onready var camera: Camera2D = find_node('MainCamera')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	Data.player = character.script_name
	C.player = character

	_nav_path = room.get_walkable_area()

	# Conectarse a señales de los hijos
	# TODO: probablemente estas señales no serán necesarias más adelante, porque
	# cada Prop y Hotspot podrá controlar lo que ocurre con los Autoload y métodos
	# estáticos.
	room.connect('prop_interacted', self, '_on_room_prop_interacted')
	room.connect('prop_looked', self, '_on_room_prop_looked')
	room.connect('hotspot_looked', self, '_on_room_hotspot_looked')
	
	character.connect('started_walk_to', self, '_update_navigation_path')
	
	room.on_room_entered()


func _process(delta):
	var walk_distance = character.walk_speed * delta
	move_along_path(walk_distance)


# The "click" event is a custom input action defined in
# Project > Project Settings > Input Map tab.
func _unhandled_input(event):
	if not event.is_action_pressed('interact'):
		return

	_update_navigation_path(character.position, get_local_mouse_position())


func move_along_path(distance):
	var last_point = character.position
	
	if path.size():
		character.walk(path.back())
		C.emit_signal('character_moved', character)
	
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points:
			character.position = last_point.linear_interpolate(
				path[0], distance / distance_between_points
			)
			camera.position = character.position

			room.character_moved(character)

			return

		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)

	character.position = last_point
	camera.position = character.position
	character.idle()
	
	C.emit_signal('character_move_ended', character)

	set_process(false)


func _update_navigation_path(start_position, end_position):
	path = _nav_path.get_simple_path(start_position, end_position, true)
	path.remove(0)
	set_process(true)


func _on_room_prop_interacted(prop: Prop, msg: String) -> void:
	_update_navigation_path(character.position, prop.walk_to_point)


func _on_room_prop_looked(prop: Prop, msg: String) -> void:
	var text: String = 'Eso es un prop de la habitación y se llama: %s' % prop.description.to_lower()
	if msg:
		text = msg
	C.emit_signal('character_spoke', character, text)


func _on_room_hotspot_looked(hotspot: Hotspot) -> void:
	I.emit_signal(
		'show_box_requested',
		'Estás viendo: %s' % hotspot.description
	)
