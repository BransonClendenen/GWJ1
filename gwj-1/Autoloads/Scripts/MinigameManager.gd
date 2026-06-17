extends Node

var active_minigame: Node = null
var minigame_container: Control = null

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
