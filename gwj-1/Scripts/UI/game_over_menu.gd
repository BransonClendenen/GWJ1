extends Control

@onready var victory: Label = $victory
@onready var waves: Label = $waves

func _ready() -> void:
	waves.text = "Waves Survived: " + str(GameState.waves_survived)
	
	if GameState.game_result == GameState.Result.WIN:
		victory.text = "You Win!"
	else:
		victory.text = "Git Gud Scrub"

func _on_return_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	GameState.change_state(GameState.State.MAIN_MENU)
