extends Node2D

@export var level_data: LevelData

@onready var wave_manager = $WaveManager
@onready var tower_manager = $TowerManager
@onready var coin_manager = $CoinManager
@onready var base_manager = $BaseManager
@onready var enemy_path = $EnemyPath
@onready var hud: Panel = $Hud
@onready var tilemap_container: Node2D = $TilemapContainer
@onready var placement_slots: Node2D = $PlacementSlots


func _ready() -> void:
	setup_level()
	connect_signals()
	wave_manager.start_next_wave()

func setup_level() -> void:
	if level_data.path_curve:
		enemy_path.curve = level_data.path_curve
	
	for child in tilemap_container.get_children():
		child.queue_free()
	if level_data.tilemap_scene:
		var tilemap = level_data.tilemap_scene.instantiate()
		tilemap_container.add_child(tilemap)
	
	for child in placement_slots.get_children():
		child.queue_free()
	if level_data.placement_slots_scene:
		var slots = level_data.placement_slots_scene.instantiate()
		placement_slots.add_child(slots)
		tower_manager.refresh_slots()
	
	coin_manager.setup(level_data.starting_coins)
	base_manager.setup(level_data.base_hp)
	wave_manager.wave_delay = level_data.wave_delay
	wave_manager.setup(level_data.waves)
	
	#references
	wave_manager.coin_manager = coin_manager
	wave_manager.base_manager = base_manager
	
	tower_manager.coin_manager = coin_manager
	
	hud.base_manager = base_manager
	hud.wave_manager = wave_manager
	hud._setup()

func connect_signals():
	base_manager.base_destroyed.connect(_on_base_destroyed)
	base_manager.base_damaged.connect(_on_base_damaged)
	
	wave_manager.wave_complete.connect(_on_wave_complete)
	wave_manager.all_waves_complete.connect(_on_all_waves_complete)
	
	coin_manager.coin_changed.connect(_on_coin_changed)

func _on_wave_complete(wave_number: int):
	#await get_tree().create_timer(3.0).timeout
	hud.on_wave_completed(wave_number)
	#wave_manager.start_next_wave()    

func _on_all_waves_complete():
	GameState.game_result = GameState.Result.WIN
	GameState.change_state(GameState.State.GAME_OVER)

func _on_base_destroyed():
	GameState.game_result = GameState.Result.LOSS
	GameState.change_state(GameState.State.GAME_OVER)

func _on_coin_changed(new_amount: int):
	pass #conenct to ui panel later

func _on_base_damaged(current_hp: int, max_hp: int):
	pass #conenct to ui panel latr

func get_coin_manager():
	return coin_manager

func get_tower_manager():
	return tower_manager
