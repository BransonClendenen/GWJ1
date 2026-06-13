extends Panel

@onready var minigame_panel = $MinigamePanel

func _ready() -> void:
	pass
	#MinigameManager.init(minigame_panel)

func _on_maze_button_pressed() -> void:
	pass
	#MinigameManager.start_minigame("maze")

func _on_pipes_button_pressed() -> void:
	pass
	#MinigameManager.start_minigame("pipes")

func _on_tiles_button_pressed() -> void:
	pass
	#MinigameManager.start_minigame("tiles")
