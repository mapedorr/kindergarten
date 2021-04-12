extends CanvasLayer

enum Type {
	NONE,
	ACTIVE,
	DOWN,
	IDLE,
	LEFT,
	LOOK,
	RIGHT,
	SEARCH,
	TALK,
	UP,
	USE,
}


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	$AnimatedSprite.position = $AnimatedSprite.get_global_mouse_position()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_cursor(type := Type.IDLE) -> void:
	var anim_name: String = Type.keys()[Type.IDLE]
	if Type.values().has(type):
		anim_name = Type.keys()[type]
	$AnimatedSprite.play(anim_name.to_lower())
