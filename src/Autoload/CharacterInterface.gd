extends Node

# El nodo Character que se movió en la escena
signal character_moved(character)
signal character_spoke(character, message)
signal character_move_ended(character)
signal character_say(chr_name, dialog)
signal character_walk_to(chr_name, position)

var player: Character


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func character_say(chr_name: String, dialog: String) -> void:
	emit_signal('character_say', chr_name, dialog)
	yield(I, 'continue_clicked')


func player_say(dialog: String) -> void:
	emit_signal('character_say', Data.player, dialog)
	yield(I, 'continue_clicked')
	player.idle()


func character_walk_to(chr_name: String, position: Vector2) -> void:
	emit_signal('character_walk_to', chr_name, position)
	yield(self, 'character_move_ended')
#	yield(get_tree().create_timer(0.2), 'timeout')


func player_walk_to(position: Vector2) -> void:
	yield(character_walk_to(Data.player, position), 'completed')


func walk_to_clicked() -> void:
	yield(character_walk_to(Data.player, Data.clicked.walk_to_point), 'completed')
# -------------------------------------- TODO: ¿Mover esto a otro Autoload? ----
