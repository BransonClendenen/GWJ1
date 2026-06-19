extends Control

@onready var level_select: Control = $level_select

func _on_button_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	level_select.open()
