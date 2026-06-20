extends Control

@onready var victory: Label = $victory
@onready var waves: Label = $waves
@onready var back_button: Button = $back_button

func _ready() -> void:
	back_button.pressed.connect(on_back_pressed)
	waves.text = "Waves Survived: " + str(GameState.waves_survived)
	
	if GameState.game_result == GameState.Result.WIN:
		victory.text = "You Win!"
	else:
		victory.text = "Git Gud Scrub"

func on_back_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	GameState.change_state(GameState.State.MAIN_MENU)
