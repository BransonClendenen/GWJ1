extends Area2D
class_name PlacementSlot

var is_occupied: bool = false
var tower: Tower = null
var tower_container:Node2D
var bullet_container:Node2D

func place_tower(tower_scene:PackedScene) -> Tower:
	if is_occupied:
		return null
	var t = tower_scene.instantiate()
	tower_container.add_child(t)
	t.global_position = global_position
	t.projectile_container = bullet_container
	tower = t
	is_occupied = true
	update_visual()
	return t

func clear_tower():
	if tower:
		tower.queue_free()
		tower = null
	is_occupied = false
	update_visual()

func update_visual():
	modulate = Color(0.4, 0.4, 0.4) if is_occupied else Color.WHITE
