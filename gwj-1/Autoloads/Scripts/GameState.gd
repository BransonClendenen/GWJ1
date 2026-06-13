extends Node

enum State {
NONE,
MAIN_MENU,
GAME,
GAME_OVER
}

var current_state: State
var previous_state: State

var main_menu#: #MainMenu
var game#: Game
var game_over_menu#: #GameOverMenu

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

func find_new_state(state):
	match state:
		State.MAIN_MENU:
			if previous_state == State.NONE:
				#first load
				SceneManager.load_ui("res://Scenes/UI/main_menu.tscn")
			else:
				#second and after load
				SceneManager.load_ui("res://Scenes/UI/main_menu.tscn")
		State.GAME:
			if previous_state == State.MAIN_MENU:
				await(SceneManager.load_ui("res://Scenes/UI/td_ui_container.tscn"))
				#SceneManager.load_scene("res://Scenes/Game/td.tscn")
				SceneManager.load_ui("res://Scenes/UI/td_map.tscn")
				SceneManager.load_ui("res://Scenes/UI/ui_panel.tscn")
		State.GAME_OVER:
			pass

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
