extends Node2D

@export var level_data: LevelData

@onready var wave_manager = $WaveManager
@onready var tower_manager = $TowerManager
@onready var coin_manager = $CoinManager
@onready var base_manager = $BaseManager
@onready var enemy_path = $EnemyPath

signal send_managers(coin_manager:Node,tower_manager:Node)

func _ready() -> void:
	setup_level()
	connect_signals()
	wave_manager.start_next_wave()

func setup_level() -> void:
	enemy_path.curve = level_data.path_curve
	coin_manager.setup(level_data.starting_coins)
	base_manager.setup(level_data.base_hp)
	wave_manager.setup(level_data.waves)
	
	#references
	wave_manager.coin_manager = coin_manager
	wave_manager.base_manager = base_manager
	
	tower_manager.coin_manager = coin_manager
	
	emit_signal(coin_manager,tower_manager)

func connect_signals():
	base_manager.base_destroyed.connect(_on_base_destroyed)
	base_manager.base_damaged.connect(_on_base_damaged)
	
	wave_manager.wave_complete.connect(_on_wave_complete)
	wave_manager.all_waves_complete.connect(_on_all_waves_complete)
	
	coin_manager.coin_changed.connect(_on_coin_changed)

func _on_wave_complete(wave_number: int):
	await get_tree().create_timer(3.0).timeout
	wave_manager.start_next_wave()    

func _on_all_waves_complete():
	GameState.change_state(GameState.State.GAME_OVER)

func _on_base_destroyed():
	GameState.change_state(GameState.State.GAME_OVER)

func _on_coin_changed(new_amount: int):
	pass #conenct to ui panel later

func _on_base_damaged(current_hp: int, max_hp: int):
	pass #conenct to ui panel latr
