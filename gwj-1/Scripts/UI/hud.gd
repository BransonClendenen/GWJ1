extends Panel

@onready var base_health: Label = $VBoxContainer/base_health
@onready var wave_count: Label = $VBoxContainer/wave_count
@onready var wave_status_label: Label = $wave_status_label
var base_manager:Node
var wave_manager:Node
var parent:Node2D

func _setup():
	base_health.text = "Base: " + str(base_manager.current_hp) + "/" + str(base_manager.max_hp)
	wave_count.text = "Wave: 0/" + str(wave_manager.waves.size())
	
	base_manager.base_damaged.connect(_on_base_damaged)
	wave_manager.wave_started.connect(_on_wave_started)

func _on_base_damaged(current_hp: int, max_hp: int) -> void:
	base_health.text = "Base: " + str(current_hp) + "/" + str(max_hp)

func _on_wave_started(wave_number: int, total_waves: int) -> void:
	wave_count.text = "Wave: " + str(wave_number) + "/" + str(total_waves)

func on_wave_completed(wave_number: int):
	wave_status_label.text = "Wave " + str(wave_number) + " Complete!"
	wave_status_label.visible = true
	await get_tree().create_timer(wave_manager.wave_delay).timeout
	wave_status_label.visible = false
