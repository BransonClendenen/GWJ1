extends Node2D

signal exited

var grid: Array = []
var tile_size: int = 16
var grid_pos: Vector2i = Vector2i(1,1)
var exit_pos: Vector2i = Vector2i(5,5)
var can_move: bool = true

func _ready() -> void:
	position = Vector2(grid_pos.x * tile_size, grid_pos.y * tile_size)

func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return
	
	var dir = Vector2i.ZERO
	
	if event.is_action_pressed("maze_up"):    dir = Vector2i(0, -1)
	elif event.is_action_pressed("maze_down"):  dir = Vector2i(0, 1)
	elif event.is_action_pressed("maze_left"):  dir = Vector2i(-1, 0)
	elif event.is_action_pressed("maze_right"): dir = Vector2i(1, 0)
	else:
		return
	
	var target = grid_pos + dir
	
	if is_walkable(target):
		grid_pos = target
		position = Vector2(grid_pos.x * tile_size, grid_pos.y * tile_size)
	
	if grid_pos == exit_pos:
		can_move = false
		emit_signal("exited")

func is_walkable(cell:Vector2i) -> bool:
	if cell.y < 0 or cell.y >= grid.size():
		return false
	if cell.x < 0 or cell.x >= grid[cell.y].size():
		return false
	return grid[cell.y][cell.x] == 0
