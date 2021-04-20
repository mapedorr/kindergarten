class_name Character
extends Clickable
# Cualquier objeto que pueda hablar, caminar, moverse entre habitaciones, tener
# inventario, entre otras muchas cosas.

# TODO: Crear la máquina de estados

signal started_walk_to(start, end)

export var text_color := Color.white
export var walk_speed := 200.0
export var is_player := false

onready var sprite: Sprite = $Sprite


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	# Conectarse a señales del cielo
	C.connect('character_say', self, '_check_say')
	C.connect('character_walk_to', self, '_check_walk')
	
	idle()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
static func walk_to_clicked() -> void:
	prints('Me lleva la verdura')


func walk(target_pos: Vector2) -> void:
	$AnimationPlayer.play('walk_r')
	$Sprite.flip_h = target_pos.x < position.x


func idle() -> void:
	$AnimationPlayer.play('idle_d')


func face_up() -> void:
	$AnimationPlayer.play('idle_u')


func face_left() -> void:
	$AnimationPlayer.play('idle_r')
	$Sprite.flip_h = true


func face_right() -> void:
	$AnimationPlayer.play('idle_r')
	$Sprite.flip_h = false


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_say(chr_name: String, dialog: String) -> void:
	if chr_name.to_lower() == script_name.to_lower():
		C.emit_signal('character_spoke', self, dialog)
		$AnimationPlayer.play('talk_d')


func _check_walk(n: String, t: Vector2) -> void:
	if n.to_lower() == script_name.to_lower():
		emit_signal('started_walk_to', position, t)
