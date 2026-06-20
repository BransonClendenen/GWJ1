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
		"Welcome to Mutated Genesis!\nDefend your base against an onslaught of military attacks as an alien presence. Place towers along the path to stop enemies and continue your conquest of the lands!",
		"Minigames\nInstead of waiting passively for money, in Mutated Genesis all your [color=#facc15]coins[/color] is earned in minigames!",
		"Game Types\nThere are three minigames, maze, pipes, and tiles, use [color=#3b82f6]wasd[/color] for the maze and your [color=#4ade80]mouse[/color] for pipes and tiles.",
		"Returns\nPlaying the same minigame for too long will [color=#f87171]reduce[/color] its payout, while others can [color=#4ade80]recover[/color] over time. Strategize to maximize returns!",
		"Towers\n[color=#4ade80]Gunner[/color] - Fast, reliable, drains stamina\n[color=#facc15]Bomber[/color] - Hits multiple targets\n[color=#3b82f6]Sniper[/color] - High damage, armor piercing",
		"Shop\n[color=#facc15]Buy[/color] your towers here! To place a tower, left click on the shop and again on the desired of the placement slots. Right click to exit placement mode.",
		"Mutations\nImprove tower performance with mutations! Click the tower you want to [color=#facc15]upgrade[/color] then go down to the mutations menu, then click and purchase the desired upgrade.",
		"Enemies\n[color=#3b82f6]Dodger[/color] - Uses stamina to dodge attacks\n[color=#4ade80]Splitter[/color] - Splits into minis on death\n[color=#f97316]Shielder[/color] - high health and armor",
		"Tips\nMaximize tower coverage with smart placements\nPlay minigames often\nHave fun!"
	]
	pictures = [
		preload("res://Sprites/Game/Towers/bomber_full.png"),
		preload("res://Sprites/Branding/Minigames.png"),
		preload("res://Sprites/Branding/GameTypes.png"),
		preload("res://Sprites/Branding/Returns.png"),
		preload("res://Sprites/Branding/Towers.png"),
		preload("res://Sprites/Branding/Shop.png"),
		preload("res://Sprites/Branding/Mutations.png"),
		preload("res://Sprites/Branding/Enemies.png"),
		preload("res://Sprites/Game/Towers/sniper_full.png"),
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
