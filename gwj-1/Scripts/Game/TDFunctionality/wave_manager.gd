extends Node

signal wave_started(wave_number: int, total_waves: int)
signal wave_complete(wave_number: int)
signal all_waves_complete

var waves: Array[WaveData] = []
var wave_delay: float = 10.0
var current_wave_index: int = 0
var enemies_alive: int = 0
var is_spawning: bool = false
var baked_points: PackedVector2Array = []

@onready var enemy_container = $"../EnemyContainer"
@onready var enemy_path = $"../EnemyPath"
var coin_manager:Node
var base_manager:Node

func setup(p_waves: Array[WaveData]):
	GameState.waves_survived = 0
	waves = p_waves
	baked_points = enemy_path.curve.get_baked_points()

func start_next_wave():
	if current_wave_index >= waves.size():
		emit_signal("all_waves_complete")
		return
	
	await get_tree().create_timer(wave_delay).timeout
	
	var wave_data = waves[current_wave_index]
	emit_signal("wave_started", current_wave_index + 1, waves.size())
	is_spawning = true
	spawn_wave(wave_data)

func spawn_wave(wave_data: WaveData):
	var spawn_list = build_spawn_list(wave_data)
	enemies_alive = spawn_list.size()
	spawn_sequence(spawn_list, wave_data.spawn_interval)

func build_spawn_list(wave_data: WaveData) -> Array[PackedScene]:
	var list: Array[PackedScene] = []
	for spawn_data in wave_data.enemies:
		for i in range(spawn_data.count):
			list.append(spawn_data.enemy_scene)
	return list

func spawn_sequence(spawn_list: Array[PackedScene], interval: float):
	for i in range(spawn_list.size()):
		await get_tree().create_timer(interval).timeout
		spawn_enemy(spawn_list[i])
	is_spawning = false

func spawn_enemy(enemy_scene: PackedScene):
	var enemy = enemy_scene.instantiate()
	enemy.wave_manager = self
	enemy_container.add_child(enemy)
	enemy.set_path(baked_points)
	enemy.died.connect(_on_enemy_died)
	enemy.reached_base.connect(_on_enemy_reached_base)
	
	if enemy is TurtlerEnemy:
		SfxManager.play_music("res://Audio/Music/3HR.MT_.3.mp3",true)
		enemy.died.connect(_on_boss_died)

func register_enemy(enemy:Enemy):
	enemy.died.connect(_on_enemy_died)
	enemy.reached_base.connect(_on_enemy_reached_base)
	enemies_alive += 1

func _on_enemy_died(reward: int):
	coin_manager.add_coins(reward)
	on_enemy_removed()

func _on_enemy_reached_base(damage: int) -> void:
	base_manager.take_damage(damage)
	on_enemy_removed()

func on_enemy_removed():
	enemies_alive -= 1
	if enemies_alive <= 0 and not is_spawning:
		enemies_alive = 0
		SfxManager.play_sfx("res://Audio/SFX/UI/sfx_wave_complete.ogg",10.0,1.2)
		emit_signal("wave_complete", current_wave_index + 1)
		current_wave_index += 1
		GameState.waves_survived += 1
		start_next_wave()

func _on_boss_died(reward):
	SfxManager.play_sfx("res://Audio/SFX/Game/sfx_boss_death2.mp3")
	SfxManager.play_sfx("res://Audio/SFX/Game/sfx_boss_death.mp3")
