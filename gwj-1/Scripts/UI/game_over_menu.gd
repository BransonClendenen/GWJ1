extends Control

@onready var victory: Label = $victory
@onready var waves: Label = $waves

func _ready() -> void:
	waves.text = "Waves Survived: " + str(GameState.waves_survived)
	
	if GameState.game_result == GameState.Result.WIN:
		victory.text = "You Win!"
	else:
		victory.text = "Fucking Loser"

func _on_return_pressed() -> void:
	GameState.change_state(GameState.State.MAIN_MENU)
