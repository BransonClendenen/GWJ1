extends Panel

@onready var minigame_panel = $minigame_panel
@onready var result_panel: Panel = $minigame_panel/result_panel
@onready var result_label: Label = $minigame_panel/result_panel/result_label
@onready var result_button: Button = $minigame_panel/result_panel/result_button

@onready var maze_button: Button = $minigame_buttons/maze_button
@onready var pipes_button: Button = $minigame_buttons/pipes_button
@onready var tiles_button: Button = $minigame_buttons/tiles_button


func _ready() -> void:
	MinigameManager.init(minigame_panel)
	MinigameManager.minigame_completed.connect(_on_minigame_completed)
	result_button.pressed.connect(_on_result_button_pressed)
	
	maze_button.pressed.connect(_on_maze_button_pressed)
	pipes_button.pressed.connect(_on_pipes_button_pressed)
	tiles_button.pressed.connect(_on_tiles_button_pressed)

func _on_maze_button_pressed() -> void:
	MinigameManager.start_minigame("maze")

func _on_pipes_button_pressed() -> void:
	pass
	#MinigameManager.start_minigame("pipes")

func _on_tiles_button_pressed() -> void:
	pass
	#MinigameManager.start_minigame("tiles")

func _on_minigame_completed(type:String,success:bool):
	var text:String
	if success == true:
		text = "Won!"
	else:
		text = "Lost..."
	result_label.text = type + " " + text
	#add money here later
	
	result_panel.visible = true

func _on_result_button_pressed():
	result_panel.visible = false
