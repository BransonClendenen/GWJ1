extends Panel

@onready var minigame_panel = $minigame_panel
@onready var result_panel: Panel = $minigame_panel/result_panel
@onready var result_label: Label = $minigame_panel/result_panel/result_label
@onready var result_button: Button = $minigame_panel/result_panel/result_button

@onready var maze_button: Button = $minigame_buttons/maze_button
@onready var pipes_button: Button = $minigame_buttons/pipes_button
@onready var tiles_button: Button = $minigame_buttons/tiles_button

@onready var coins_label: Label = $coins_panel/coins_label

@onready var gunner_button: Button = $shop_panel/gunner_card/button
@onready var bomber_button: Button = $shop_panel/bomber_card/button
@onready var sniper_button: Button = $shop_panel/sniper_card/button

@export var gunner_scene: PackedScene = preload("res://Scenes/Game/Towers/gunner.tscn")
@export var bomber_scene: PackedScene = preload("res://Scenes/Game/Towers/bomber.tscn")
@export var sniper_scene: PackedScene = preload("res://Scenes/Game/Towers/sniper.tscn")

@export var gunner_preview_texture = preload("res://Sprites/Game/Towers/gunner_full.png")
@export var bomber_preview_texture = preload("res://Sprites/Game/Towers/bomber_full.png")
@export var sniper_preview_texture = preload("res://Sprites/Game/Towers/sniper_full.png")


var tower_manager:Node
var coin_manager:Node

func _ready() -> void:
	MinigameManager.init(minigame_panel)
	MinigameManager.minigame_completed.connect(_on_minigame_completed)
	MinigameManager.reset_streaks()
	result_button.pressed.connect(_on_result_button_pressed)
	
	maze_button.pressed.connect(_on_maze_button_pressed)
	pipes_button.pressed.connect(_on_pipes_button_pressed)
	tiles_button.pressed.connect(_on_tiles_button_pressed)
	
	coin_manager = GameState.collect_coin_manager()
	tower_manager = GameState.collect_tower_manager()
	
	coin_manager.coin_changed.connect(_on_coin_changed)
	coins_label.text = "Coins: " + str(coin_manager.coins)
	
	gunner_button.pressed.connect(_on_gunner_button_pressed)
	bomber_button.pressed.connect(_on_bomber_button_pressed)
	sniper_button.pressed.connect(_on_sniper_button_pressed)
	
	refresh_minigame_button_colors()

func _on_maze_button_pressed() -> void:
	if result_panel.visible:
		return
	MinigameManager.start_minigame("maze")
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_minigame_start.ogg")

func _on_pipes_button_pressed() -> void:
	if result_panel.visible:
		return
	MinigameManager.start_minigame("pipes")
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_minigame_start.ogg")

func _on_tiles_button_pressed() -> void:
	if result_panel.visible:
		return
	MinigameManager.start_minigame("tiles")
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_minigame_start.ogg")

func _on_minigame_completed(type:String,success:bool):
	if not success:
		result_label.text = type + " - Lost"
		result_panel.visible = true
		refresh_minigame_button_colors()
		SfxManager.play_sfx("res://Audio/SFX/UI/sfx_minigame_fail.wav")
		return
	
	# Get multiplier BEFORE updating streak so first play is always full reward
	var multiplier = MinigameManager.get_reward_multiplier(type)
	
	var base_reward: int
	match type:
		"maze":  base_reward = 15
		"pipes": base_reward = 20
		"tiles": base_reward = 50
		_:       base_reward = 0
	
	var final_reward = int(base_reward * multiplier)
	coin_manager.add_coins(final_reward)
	
	MinigameManager.update_streak(type)
	
	# Show the player what they earned and whether it was reduced
	result_label.text = type + " — Won\n+" + str(final_reward) + " coins"
	
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_minigame_win.wav")
	result_panel.visible = true
	refresh_minigame_button_colors()

func refresh_minigame_button_colors():
	set_button_color(maze_button, "maze")
	set_button_color(pipes_button, "pipes")
	set_button_color(tiles_button, "tiles")

func set_button_color(button: Button, type: String):
	var multiplier = MinigameManager.get_reward_multiplier(type)
	if multiplier < 1.0:
		button.modulate = Color(0.9, 0.3, 0.3)
	elif multiplier > 1.0:
		button.modulate = Color(0.3, 0.9, 0.3)
	else:
		button.modulate = Color(0.7, 0.7, 0.7)

func _on_result_button_pressed():
	result_panel.visible = false

func _on_coin_changed(new_amount):
	coins_label.text = "Coins: " + str(new_amount)

func _on_gunner_button_pressed():
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	tower_manager.select_tower(gunner_scene, 60, gunner_preview_texture)

func _on_bomber_button_pressed():
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	tower_manager.select_tower(bomber_scene, 70, bomber_preview_texture)

func _on_sniper_button_pressed():
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	tower_manager.select_tower(sniper_scene, 80, sniper_preview_texture)
