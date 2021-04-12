class_name Character
extends Node2D

# TODO: Crear la máquina de estados

export var text_color: Color = Color.white
export var walk_speed := 200.0

onready var sprite: Sprite = $Sprite

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	idle()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func walk(target_pos: Vector2) -> void:
	$AnimationPlayer.play('walk_r')
	$Sprite.flip_h = target_pos.x < position.x


func idle() -> void:
	$AnimationPlayer.play('idle_d')
