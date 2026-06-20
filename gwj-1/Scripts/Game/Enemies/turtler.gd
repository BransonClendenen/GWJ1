extends Enemy
class_name TurtlerEnemy

@export var splitter_scene: PackedScene = preload("res://Scenes/Game/Enemies/splitter.tscn")
const SPLIT_COUNT = 6
const SPAWN_SPREAD = 6.0

func _ready():
	enemy_name = "Turtler"
	max_hp = 400
	max_stamina = 0
	max_armor = 1000
	armor_reduction = 0.99
	speed = 10
	coin_reward = 100
	damage_to_base = 100
	super._ready()

func on_armor_broken():
	max_stamina = max_hp/2.0
	current_stamina = max_stamina
	speed = 20
	update_stamina_bar()
	VfxManager.burst(get_parent(), global_position, Color.ORANGE, 24, 0.6)
	VfxManager.flash(self, Color.ORANGE)

func on_death():
	if not splitter_scene:
		push_error("SplitterEnemy: mini_scene not assigned")
		return
	
	for i in range(SPLIT_COUNT):
		var splitter = splitter_scene.instantiate()
		get_parent().add_child(splitter)
		
		var angle = (TAU / SPLIT_COUNT) * i
		var offset = Vector2(cos(angle), sin(angle)) * SPAWN_SPREAD
		splitter.global_position = global_position + offset
		
		splitter.set_path_from_index(path_points, path_index)
		wave_manager.register_enemy(splitter)
