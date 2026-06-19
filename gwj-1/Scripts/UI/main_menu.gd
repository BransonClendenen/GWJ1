extends Control

@onready var level_select: Control = $level_select

func _on_button_pressed() -> void:
	level_select.open()
