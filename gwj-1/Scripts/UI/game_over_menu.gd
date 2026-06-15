extends Control

func _on_return_pressed() -> void:
	GameState.change_state(GameState.State.MAIN_MENU)
