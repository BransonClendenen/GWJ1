extends Node

signal base_damaged(current_hp: int, max_hp: int)
signal base_destroyed

var current_hp: int = 0
var max_hp: int = 100

func setup(p_max_hp: int) -> void:
	max_hp = p_max_hp
	current_hp = max_hp
	emit_signal("base_damaged", current_hp, max_hp)

func take_damage(amount: int) -> void:
	current_hp = clamp(current_hp - amount, 0, max_hp)
	emit_signal("base_damaged", current_hp, max_hp)
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_base_damage.wav")
	#VfxManager.screen_shake($"../".get_viewport().get_camera_2d(), 2.0, 0.2)
	#add camera so ts works
	if current_hp <= 0:
		SfxManager.play_sfx("res://Audio/SFX/UI/sfx_base_destroyed.ogg")
		emit_signal("base_destroyed")
