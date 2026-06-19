extends Enemy
class_name SplitterEnemy

@export var mini_scene: PackedScene = preload("res://Scenes/Game/Enemies/mini.tscn")
const SPLIT_COUNT = 6
const SPAWN_SPREAD = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Splitter"
	max_hp = 20
	max_stamina = 0
	max_armor = 0
	speed = 35
	coin_reward = 1
	damage_to_base = 5
	super._ready()

func on_death():
	if not mini_scene:
		push_error("SplitterEnemy: mini_scene not assigned")
		return
	
	for i in range(SPLIT_COUNT):
		var mini = mini_scene.instantiate()
		get_parent().add_child(mini)
		
		var angle = (TAU / SPLIT_COUNT) * i
		var offset = Vector2(cos(angle), sin(angle)) * SPAWN_SPREAD
		mini.global_position = global_position + offset
		
		mini.set_path_from_index(path_points, path_index)
		wave_manager.register_enemy(mini)
