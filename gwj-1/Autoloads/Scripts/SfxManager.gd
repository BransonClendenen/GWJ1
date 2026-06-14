extends Node

const POOL_SIZE = 8

var _music_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _pool_index: int = 0
var _sfx_cache: Dictionary = {}

func _ready() -> void:
	_music_player = $MusicPlayer
	_build_pool()

func _build_pool() -> void:
	var pool_node = $SfxPool
	for i in range(POOL_SIZE):
		var player := AudioStreamPlayer.new()
		pool_node.add_child(player)
		_sfx_pool.append(player)

func play_music(path: String, volume_db: float = 0.0, loop: bool = true) -> void:
	var stream = _load_stream(path)
	if stream == null:
		return
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.volume_db = volume_db
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()

func set_music_volume(volume_db: float) -> void:
	_music_player.volume_db = volume_db

func pause_music(paused: bool) -> void:
	_music_player.stream_paused = paused

func play_sfx(path: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	var stream = _load_stream(path)
	if stream == null:
		return
	var player = _get_next_player()
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.play()

func play_sfx_pitched(path:String,pitch_variance:float=0.1) -> void:
	var pitch = 1.0 + randf_range(-pitch_variance, pitch_variance)
	play_sfx(path, 0.0, pitch)

func _get_next_player() -> AudioStreamPlayer:
	var player = _sfx_pool[_pool_index]
	_pool_index = (_pool_index + 1) % POOL_SIZE
	return player

func _load_stream(path: String) -> AudioStream:
	if _sfx_cache.has(path):
		return _sfx_cache[path]
	if not ResourceLoader.exists(path):
		push_error("SfxManager: file not found — " + path)
		return null
	var stream = load(path)
	_sfx_cache[path] = stream
	return stream
