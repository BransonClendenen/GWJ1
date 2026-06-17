extends Control

signal completed(success: bool)

const GRID_SIZE = 4 #4x4 = 16 tiles = 8 pairs
var tile_values: Array = []
var flipped_tiles: Array = []
var matched_pairs: int = 0
var moves_remaining: int = 20

@onready var grid_container: GridContainer = $GridContainer
@onready var status_label: Label = $StatusLabel

func _ready() -> void:
	randomize()
	setup_deck()
	create_tile_buttons()
	status_label.text = "Moves: " + str(moves_remaining)

func setup_deck() -> void:
	tile_values.clear()
	var pairs = ["A", "B", "C", "D", "E", "F", "G", "H"]
	for val in pairs:
		tile_values.append(val)
		tile_values.append(val)
	tile_values.shuffle()

func create_tile_buttons() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	for i in range(tile_values.size()):
		var btn = Button.new()
		btn.custom_minimum_size = Vector2(10, 10)
		btn.text = "?"
		btn.pressed.connect(_on_tile_pressed.bind(i, btn))
		grid_container.add_child(btn)

func _on_tile_pressed(index: int, btn: Button) -> void:
	if flipped_tiles.size() >= 2 or btn.text != "?":
		return
	btn.text = tile_values[index]
	flipped_tiles.append({ "index": index, "button": btn})
	if flipped_tiles.size() == 2:
		moves_remaining -= 1
		status_label.text = "Moves: " + str(moves_remaining)
		get_tree().create_timer(0.6).timeout.connect(check_match)

func check_match() -> void:
	var t1 = flipped_tiles[0]
	var t2 = flipped_tiles[1]
	if tile_values[t1.index] == tile_values[t2.index]:
		matched_pairs += 1
		t1.button.disabled = true
		t2.button.disabled = true
	else:
		t1.button.text = "?"
		t2.button.text = "?"
	flipped_tiles.clear()
	if matched_pairs == 8:
		emit_signal("completed", true)
	elif moves_remaining <= 0:
		emit_signal("completed", false)
