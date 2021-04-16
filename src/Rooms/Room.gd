# TODO: Crear un icono para este tipo de nodos
class_name Room
extends Node2D
# Nodo base para la creación de habitaciones dentro del juego.

# TODO: Tal vez estas podrían reducirse a dos señales: item_interacted y item_looked.
# Y los Props y Hotspots podrían heredar de Item.
signal prop_interacted(prop, msg)
signal prop_looked(prop, msg)
signal hotspot_interacted(hotspot)
signal hotspot_looked(hotspot)

var _props := []
var _hotspots := []


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	for p in $Props.get_children():
		# TODO: Esta validación de baseline no será necesaria cuando sean Props
		if p.get('baseline'):
			var prop: Prop = p as Prop
			prop.connect('interacted', self, '_on_prop_interacted', [p])
			prop.connect('looked', self, '_on_prop_looked', [p])

			_props.append(prop)
	
	for h in $Hotspots.get_children():
		var hotspot: Hotspot = h
		hotspot.connect(
			'interacted', self, 'emit_signal', ['hotspot_interacted', hotspot]
		)
		hotspot.connect(
			'looked', self, 'emit_signal', ['hotspot_looked', hotspot]
		)
		
		_hotspots.append(hotspot)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func get_walkable_area() -> Navigation2D:
	return $WalkableAreas.get_child(0) as Navigation2D


func character_moved(chr: Character) -> void:
	for p in _props:
		if p:
			var prop: Node2D = p
			var baseline: float = prop.to_global(Vector2.DOWN * prop.baseline).y
			if baseline > chr.global_position.y:
				p.z_index = 1
			else:
				p.z_index = 0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _on_prop_interacted(msg: String, prop: Prop) -> void:
	emit_signal('prop_interacted', prop, msg)


func _on_prop_looked(msg: String, prop: Prop) -> void:
	emit_signal('prop_looked', prop, msg)
