extends Control

@onready var level_select: Control = $level_select
@onready var game_button: Button = $game_button
@onready var help_button: Button = $help_button
@onready var credits_button: Button = $credits_button
@onready var credits_overlay: Control = $credits_overlay
@onready var help_overlay: Control = $help_overlay

func _ready() -> void:
	game_button.pressed.connect(on_game_pressed)
	help_button.pressed.connect(on_help_pressed)
	credits_button.pressed.connect(on_credits_pressed)

func on_game_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	level_select.open()

func on_help_pressed():
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	help_overlay.open()

func on_credits_pressed():
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	credits_overlay.open()
