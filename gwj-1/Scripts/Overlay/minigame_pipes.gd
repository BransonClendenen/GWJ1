extends Control

signal completed(succss: bool)

const GRID_SIZE = 4
const TILE_SIZE = 16

enum Dir {NORTH = 1, EAST = 2, SOUTH = 4, WEST = 8}

@export var straight_texture: Texture2D
@export var elbow_texture: Texture2D
@export var t_junction_texture: Texture2D

const PIPE_TYPES = {
	"straight": [Dir.NORTH | Dir.SOUTH, Dir.EAST | Dir.WEST],
	"elbow": [Dir.NORTH | Dir.EAST, Dir.EAST | Dir.SOUTH, Dir.SOUTH | Dir.WEST, Dir.WEST | Dir.NORTH],
	"t_junction": [Dir.WEST | Dir.NORTH | Dir.EAST, Dir.NORTH | Dir.EAST | Dir.SOUTH, Dir.EAST | Dir.SOUTH | Dir.WEST, Dir.SOUTH | Dir.WEST | Dir.NORTH]
}

var grid: Array = []
var start_cell: Vector2i = Vector2i(0, 0)
var end_cell: Vector2i = Vector2i(3, 3)

@onready var grid_container: Control = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	setup_grid()
	draw_grid()

func setup_grid() -> void:
	grid.clear()
	for y in range(GRID_SIZE):
		var row = []
		for x in range(GRID_SIZE):
			var type = PIPE_TYPES.keys().pick_random()
			var rot = randi() % PIPE_TYPES[type].size()
			row.append({"type": type, "rot": rot})
		grid.append(row)

func draw_grid() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var btn = Button.new()
			btn.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
			btn.position = Vector2(x * TILE_SIZE, y * TILE_SIZE)
			btn.flat = true
			
			var pipe_visual = TextureRect.new()
			pipe_visual.size = Vector2(TILE_SIZE, TILE_SIZE)
			pipe_visual.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			pipe_visual.stretch_mode = TextureRect.STRETCH_SCALE
			pipe_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
			pipe_visual.pivot_offset = Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)
			btn.add_child(pipe_visual)
			
			update_button_visual(btn, x, y)
			btn.pressed.connect(_on_tile_pressed.bind(x, y, btn))
			grid_container.add_child(btn)
			
			if Vector2i(x, y) == start_cell:
				btn.flat = false
				btn.modulate = Color(0.4, 1.0, 0.4)
			elif Vector2i(x, y) == end_cell:
				btn.flat = false
				btn.modulate = Color(0.4, 1.0, 0.4)

func update_button_visual(btn: Button, x: int, y: int) -> void:
	var cell = grid[y][x]
	var pipe_visual: TextureRect = btn.get_child(0)
	
	match cell.type:
		"straight":
			pipe_visual.texture = straight_texture
			pipe_visual.rotation_degrees = 90.0 if cell.rot == 1 else 0.0
		"elbow":
			pipe_visual.texture = elbow_texture
			pipe_visual.rotation_degrees = (cell.rot * 90.0) + 180.0
		"t_junction":
			pipe_visual.texture = t_junction_texture
			pipe_visual.rotation_degrees = (cell.rot * 90.0) + 180.0

func _on_tile_pressed(x: int, y: int, btn: Button) -> void:
	var cell = grid[y][x]
	var allowed_rotations = PIPE_TYPES[cell.type].size()
	cell.rot = (cell.rot + 1) % allowed_rotations
	update_button_visual(btn, x, y)
	if check_connection():
		_on_win()

func get_cell_connections(x: int, y: int) -> int:
	var cell = grid[y][x]
	return PIPE_TYPES[cell.type][cell.rot]

func check_connection() -> bool:
	var visited: Array[Vector2i] = []
	var queue: Array[Vector2i] = [start_cell]
	while queue.size() > 0:
		var curr: Vector2i = queue.pop_front()
		if curr in visited:
			continue
		visited.append(curr)
		if curr == end_cell:
			return true
		var conn = get_cell_connections(curr.x, curr.y)
		if (conn & Dir.NORTH) and curr.y > 0:
			var n = Vector2i(curr.x, curr.y - 1)
			if get_cell_connections(n.x, n.y) & Dir.SOUTH:
				queue.append(n)
		if (conn & Dir.SOUTH) and curr.y < GRID_SIZE - 1:
			var n = Vector2i(curr.x, curr.y + 1)
			if get_cell_connections(n.x, n.y) & Dir.NORTH:
				queue.append(n)
		if (conn & Dir.EAST) and curr.x < GRID_SIZE - 1:
			var n = Vector2i(curr.x + 1, curr.y)
			if get_cell_connections(n.x, n.y) & Dir.WEST:
				queue.append(n)
		if (conn & Dir.WEST) and curr.x > 0:
			var n = Vector2i(curr.x - 1, curr.y)
			if get_cell_connections(n.x, n.y) & Dir.EAST:
				queue.append(n)
	return false

func _on_win() -> void:
	emit_signal("completed", true)
