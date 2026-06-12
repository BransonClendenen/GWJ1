extends Control

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	GameState.change_state(GameState.State.GAME)
