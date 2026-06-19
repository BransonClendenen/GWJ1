extends Node

var active_minigame: Node = null
var minigame_container: Control = null

# Stale reward tracking
var play_streaks: Dictionary = {"maze": 0, "pipes": 0, "tiles": 0}
var neglect_counts: Dictionary = {"maze": 0, "pipes": 0, "tiles": 0}

const PENALTY_THRESHOLD = 2
const PENALTY_MULTIPLIER = 0.5

const BONUS_THRESHOLD = 3
const BONUS_MULTIPLIER = 2.0

signal minigame_completed(type:String,success:bool)

func init(container:Control) -> void:
	minigame_container = container

func start_minigame(type:String):
	if active_minigame != null:
		#doesnt allow multiple games to run
		return
	
	var path = ""
	match type:
		"maze":path = "res://Scenes/Overlay/minigame_maze.tscn"
		"pipes": path = "res://Scenes/Overlay/minigame_pipes.tscn"
		"tiles": path = "res://Scenes/Overlay/minigame_tiles.tscn"
	
	if path == "":
		push_error("Unknown minigame id: " + type)
		return
	
	var scene = load(path).instantiate()
	minigame_container.add_child(scene)
	active_minigame = scene
	active_minigame.completed.connect(_on_minigame_completed.bind(type))

func _on_minigame_completed(success:bool,type:String,):
	emit_signal("minigame_completed",type,success)
	if active_minigame:
		active_minigame.queue_free()
		active_minigame = null

func is_running() -> bool:
	return active_minigame != null

func get_reward_multiplier(type: String) -> float:
	if play_streaks[type] >= PENALTY_THRESHOLD:
		return PENALTY_MULTIPLIER
	if neglect_counts[type] >= BONUS_THRESHOLD:
		return BONUS_MULTIPLIER
	return 1.0

func update_streak(played_type: String) -> void:
	for type in play_streaks.keys():
		if type == played_type:
			play_streaks[type] += 1
			neglect_counts[type] = 0
		else:
			play_streaks[type] = 0
			neglect_counts[type] += 1

func reset_streaks():
	play_streaks = {"maze": 0, "pipes": 0, "tiles": 0}
	neglect_counts = {"maze": 0, "pipes": 0, "tiles": 0}
