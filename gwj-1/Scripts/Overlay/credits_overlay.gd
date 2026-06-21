extends Control

@onready var close_button: Button = $close_button
@onready var insta: TextureButton = $insta

func _ready() -> void:
	visible = false
	close_button.pressed.connect(_on_close_pressed)
	insta.pressed.connect(on_insta_pressed)

func open() -> void:
	visible = true

func _on_close_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	visible = false

func on_insta_pressed():
	OS.shell_open("https://www.instagram.com/morphiendgames/")
