# TODO: Crear un icono para este tipo de nodos
class_name Room
extends Node2D
# Nodo base para la creación de habitaciones dentro del juego.

signal prop_interacted(prop)
signal prop_looked(prop)
signal hotspot_interacted(hotspot)

var _props := []
var _hotspots := []


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	for p in $Props.get_children():
		# TODO: Esta validación de baseline no será necesaria cuando sean Props
		if p.get('baseline'):
			var prop: Prop = p as Prop
			prop.connect(
				'interacted', self, 'emit_signal', ['prop_interacted', p]
			)
			prop.connect('looked', self, 'emit_signal', ['prop_looked', p])

			_props.append(prop)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func get_walkable_area() -> Navigation2D:
	return $WalkableAreas.get_child(0) as Navigation2D


func character_moved(chr: Character) -> void:
	for p in _props:
		var prop: Node2D = p
		var baseline: float = prop.to_global(Vector2.DOWN * prop.baseline).y
		if baseline > chr.global_position.y:
			p.z_index = 1
		else:
			p.z_index = 0
