extends Node2D

export(float) var character_speed = 400.0

var path = []

var _nav_path: Navigation2D

onready var character: Character = find_node('Character')
onready var room: Room = find_node('Room')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	_nav_path = room.get_walkable_area()
	room.connect('prop_interacted', self, '_on_room_prop_interacted')
	room.connect('prop_looked', self, '_on_room_prop_looked')


func _process(delta):
	var walk_distance = character_speed * delta
	move_along_path(walk_distance)


# The "click" event is a custom input action defined in
# Project > Project Settings > Input Map tab.
func _unhandled_input(event):
	if not event.is_action_pressed('interact'):
		return
	_update_navigation_path(character.position, get_local_mouse_position())


func move_along_path(distance):
	var last_point = character.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])
		# The position to move to falls between two points.
		if distance <= distance_between_points:
			character.position = last_point.linear_interpolate(
				path[0], distance / distance_between_points
			)
			
			# TODO: ¿Evaluar los base line de los Hotspot y Props dentro de la
			# habitación para cambiar el z-index?
			room.character_moved(character)
			
			return
		# The position is past the end of the segment.
		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)
	# The character reached the end of the path.
	character.position = last_point
	set_process(false)


func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class.
	# It returns a PoolVector2Array of points that lead you
	# from the start_position to the end_position.
	path = _nav_path.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position.
	# We don't need it in this example as it corresponds to the character's position.
	path.remove(0)
	set_process(true)


func _on_room_prop_interacted(prop: Prop) -> void:
	_update_navigation_path(character.position, prop.walk_to_point)


func _on_room_prop_looked(prop: Prop) -> void:
	InterfaceEvents.emit_signal(
		'character_spoke', character, 'Eso es un %s' % prop.description.to_lower()
	)