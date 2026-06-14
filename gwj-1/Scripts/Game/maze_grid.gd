extends Node2D

@export var wall_texture: Texture2D
@export var floor_texture: Texture2D

var sprites: Array = []

func build(grid: Array, tile_size: int) -> void:
	for s in sprites:
		s.queue_free()
	sprites.clear()
	
	var insert_index = 0
	for row in range(grid.size()):
		for col in range(grid[row].size()):
			var sprite := Sprite2D.new()
			sprite.texture = wall_texture if grid[row][col] == 1 else floor_texture
			sprite.position = Vector2(col * tile_size, row * tile_size)
			sprite.centered = false
			
			if row == 0 or row == grid.size()-1 or col == 0 or col == grid[row].size()-1:
				sprite.visible = false
			
			add_child(sprite)
			move_child(sprite, insert_index)
			insert_index += 1
			sprites.append(sprite)
