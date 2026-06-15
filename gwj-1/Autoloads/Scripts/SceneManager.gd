extends Node

@onready var root_node: Node = null
@onready var game_scene: Node = null
@onready var overlay_scene: Node = null
@onready var overlay_stack: Array = []

@onready var game_layer: Node = null
@onready var ui_layer: Control = null
@onready var overlay_layer: Control = null

func _ready() -> void:
	setup_layers()

func setup_layers() -> void:
	root_node = get_tree().current_scene
	game_layer = root_node.get_node("GameLayer")
	ui_layer = root_node.get_node("UILayer/UIContainer")
	overlay_layer = root_node.get_node("OverlayLayer/OverlayContainer")

func load_scene(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	#clear_scenes()
	#clear_ui()
	
	var new_game_layer = load(scene_path).instantiate()
	game_layer.add_child(new_game_layer)
	game_scene = new_game_layer
	return game_scene

func load_ui(scene_path: String):
	if not root_node:
		push_error("Main node not found.")
		return
	
	#clear_scenes()
	clear_ui()
	
	var new_ui_layer = load(scene_path).instantiate()
	#new_ui_layer.size = get_viewport().size
	ui_layer.add_child(new_ui_layer)
	return new_ui_layer

func load_overlay(scene_path: String):
	var new_overlay_layer = load(scene_path).instantiate()
	#new_overlay_layer.size = get_viewport().size
	overlay_layer.add_child(new_overlay_layer)
	overlay_scene = new_overlay_layer
	overlay_stack.append(new_overlay_layer)
	return new_overlay_layer

func hide_top_overlay():
	if overlay_stack.is_empty():
		return
	
	var top_overlay = overlay_stack.pop_back()
	top_overlay.queue_free()
	#print("Overlay hidden. Remaining overlays:", overlay_stack.size())

func hide_all_overlays():
	for overlay in overlay_stack:
		overlay.queue_free()
	overlay_stack.clear()
	overlay_scene = null
	#print("All overlays cleared")

func clear_scenes():
	game_layer.get_children().map(func(child): child.queue_free())

func clear_ui():
	ui_layer.get_children().map(func(child): child.queue_free())
