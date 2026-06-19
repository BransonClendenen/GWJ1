extends Control

@export var level_1_data: LevelData
@export var level_2_data: LevelData

@onready var level_1_button: Button = $menu/Button
@onready var level_2_button: Button = $menu2/Button

func _ready() -> void:
	visible = false
	level_1_button.pressed.connect(_on_level_1_pressed)
	level_2_button.pressed.connect(_on_level_2_pressed)

func open() -> void:
	visible = true

func close() -> void:
	visible = false

func _on_level_1_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	GameState.set_level_data(level_1_data)
	GameState.change_state(GameState.State.GAME)

func _on_level_2_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	GameState.set_level_data(level_2_data)
	GameState.change_state(GameState.State.GAME)
