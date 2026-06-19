extends Node

enum State {
NONE,
MAIN_MENU,
GAME,
GAME_OVER
}

enum Result {
	NONE,
	WIN,
	LOSS
}

var current_state: State
var previous_state: State

var main_menu#: #MainMenu
var game_over_menu#: #GameOverMenu
var td_scene:Node2D
var ui_panel:Control
var upgrade_panel:Control

var selected_level_data:LevelData = null

var game_result: Result = Result.NONE
var waves_survived:int = 0

#signal state_changed(new_state)

func set_state(new_state: State):
	if new_state == current_state:
		return
	
	#emit_signal("state_changing", current_state, new_state)
	previous_state = current_state
	current_state = new_state
	
	find_new_state(current_state)

func change_state(new_state:State):
	set_state(new_state)

func set_level_data(level_data:LevelData):
	selected_level_data = level_data

func find_new_state(state):
	match state:
		State.MAIN_MENU:
			if previous_state == State.NONE:
				#first load
				main_menu = SceneManager.load_ui("res://Scenes/UI/main_menu.tscn")
			else:
				#second and after load
				main_menu = SceneManager.load_ui("res://Scenes/UI/main_menu.tscn")
		State.GAME:
			if previous_state == State.MAIN_MENU:
				#await(SceneManager.load_ui("res://Scenes/UI/td_ui_container.tscn"))
				#SceneManager.load_ui("res://Scenes/UI/td_map.tscn")
				td_scene = SceneManager.load_scene("res://Scenes/Game/td.tscn")
				ui_panel = SceneManager.load_ui("res://Scenes/UI/ui_panel.tscn")
				upgrade_panel = SceneManager.load_overlay("res://Scenes/Overlay/upgrade_panel.tscn")
				main_menu.queue_free()
		State.GAME_OVER:
			game_over_menu = SceneManager.load_ui("res://Scenes/UI/game_over_menu.tscn")
			td_scene.queue_free()
			ui_panel.queue_free()
			upgrade_panel.queue_free()

func collect_coin_manager():
	return td_scene.get_coin_manager()

func collect_tower_manager():
	return td_scene.get_tower_manager()

#if need pause scene but no delete 
#(also hides scene so we can remove that if needed)
func enable_processes(node):
	node.get_tree().paused = false
	node.visible = true
	node.show()

func disable_processes(node):
	node.get_tree().paused = true
	node.visible = false
	node.hide()
