extends Control

@export var pictures: Array[Texture2D]
@export var pages: Array[String]

var current_page: int = 0

@onready var close_button: Button = $close_button
@onready var next_button: Button = $next_button
@onready var prev_button: Button = $prev_button
@onready var page_display: TextureRect = $page_display
@onready var page_text: RichTextLabel = $page_text

func _ready() -> void:
	pages = [
		"sigma gooned",
		"bigma sooned"
	]
	pictures = [
		preload("res://Sprites/Game/Towers/bomber_full.png"),
		preload("res://Sprites/Game/Towers/sniper_bullet.png")
	]
	visible = false
	next_button.pressed.connect(on_next_pressed)
	prev_button.pressed.connect(on_prev_pressed)
	close_button.pressed.connect(on_close_pressed)

func open() -> void:
	current_page = 0
	visible = true
	refresh_page()

func on_close_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	visible = false

func on_next_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	if current_page < pages.size() - 1:
		current_page += 1
		refresh_page()

func on_prev_pressed() -> void:
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_ui_click.ogg")
	if current_page > 0:
		current_page -= 1
		refresh_page()

func refresh_page() -> void:
	page_display.texture = pictures[current_page]
	page_text.text = pages[current_page]
	prev_button.disabled = current_page == 0
	next_button.disabled = current_page == pages.size() - 1
