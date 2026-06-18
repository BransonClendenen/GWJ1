extends Control

signal completed(success:bool)

@onready var grid: Node2D = $grid
@onready var player: Node2D = $grid/player
@onready var exit: Node2D = $grid/exit

var preset: Dictionary
const TILE_SIZE = 16
const GRID_SCALE = 0.75

func _ready() -> void:
	preset = MazePresets.get_random_preset()
	
	grid.scale = Vector2(GRID_SCALE,GRID_SCALE)
	
	var grid_pixel_size = 8 * TILE_SIZE * GRID_SCALE
	grid.position = Vector2(
		(103 - grid_pixel_size) / 2.0,
		(90  - grid_pixel_size) / 2.0
	)
	
	grid.build(preset.grid,TILE_SIZE)
	
	player.position = grid_to_pixel(preset.spawn)
	player.tile_size = TILE_SIZE
	player.grid = preset.grid
	player.exit_pos = preset.exit
	player.exited.connect(_on_player_exited)
	
	exit.position = Vector2(preset.exit.x * TILE_SIZE, preset.exit.y * TILE_SIZE)

func grid_to_pixel(cell: Vector2i) -> Vector2:
		return Vector2(cell.x*TILE_SIZE,cell.y*TILE_SIZE)

func _on_player_exited() -> void:
	player.set_process_unhandled_input(false)
	emit_signal("completed",true)
	
