extends Node2D
class_name Enemy

@export var enemy_name: String
@export var max_hp: float
@export var max_stamina: float
@export var max_armor: float
@export var speed: float
@export var coin_reward: int
@export var damage_to_base: int

var current_hp: float
var current_stamina: float
var current_armor: float
var armor_reduction: float
var is_dead: bool = false
var wave_manager: Node

var path_points: PackedVector2Array = []
var path_index: int = 0

@onready var sprite: Sprite2D = $sprite
@onready var bgbar: ColorRect = $hpbar/bgbar
@onready var fillbar: ColorRect = $hpbar/fillbar
@onready var staminabar: ColorRect = $hpbar/staminabar
@onready var armorbar: ColorRect = $hpbar/armorbar

signal died(reward:int)
signal reached_base(damage:int)

func _ready():
	current_hp = max_hp
	current_stamina = max_stamina
	current_armor = max_armor
	update_hp_bar()
	update_stamina_bar()
	update_armor_bar()

func _process(delta: float) -> void:
	if is_dead:
		return
	follow_path(delta)

func follow_path(delta:float):
	if path_index >= path_points.size():
		on_reached_base()
		return
	
	var target = path_points[path_index]
	var direction = (target - global_position).normalized()
	global_position += direction * speed * delta
	
	if global_position.distance_to(target) < 2.0:
		path_index += 1

func set_path(points: PackedVector2Array):
	path_points = points
	path_index = 0

func set_path_from_index(points: PackedVector2Array, from_index: int) -> void:
	path_points = points
	path_index = from_index


func take_damage(amount:float,pierce:float = 0.0,stamina_drain: float = 0.0):
	if is_dead:
		return
	
	var final_damage = amount
	
	if current_stamina > 0.0:
		if stamina_drain > 0.0:
			drain_stamina(stamina_drain)
		else:
			drain_stamina(amount * 0.1)
		on_hit()
		return
	
	if current_armor > 0.0:
		var safe_pierce = clamp(pierce, 0.0, 1.0)
		var armor_damage = amount * (1 + safe_pierce)
		current_armor = clamp(current_armor - armor_damage, 0.0, max_armor)
		update_armor_bar()
		on_armor_changed(current_armor)
		if current_armor <= 0.0:
			on_armor_broken()
		VfxManager.flash(self)
		on_hit()
		return
	
	current_hp -= final_damage
	update_hp_bar()
	VfxManager.flash(self)
	on_hit()
	if current_hp <= 0:
		die()

func drain_stamina(amount:float):
	if max_stamina == 0.0:
		return
	current_stamina = clamp(current_stamina-amount,0.0,max_stamina)
	update_stamina_bar()
	on_stamina_changed(current_stamina)

func restore_stamina(amount:float):
	if max_stamina == 0.0:
		return
	current_stamina = clamp(current_stamina+amount,0.0,max_stamina)
	update_stamina_bar()
	on_stamina_changed(current_stamina)

func on_hit():
	pass #update later for dodge

func update_hp_bar() -> void:
	fillbar.size.x = bgbar.size.x * (current_hp / max_hp)

func update_stamina_bar():
	if max_stamina == 0.0:
		staminabar.visible = false
		return
	staminabar.size.x = bgbar.size.x * (current_stamina / max_stamina)

func update_armor_bar():
	if max_armor == 0.0:
		armorbar.visible = false
		return
	armorbar.size.x = bgbar.size.x * (current_armor / max_armor)

func on_stamina_changed(new_stamina:float):
	pass #override in dodger
	#enable/disable dodging
	#also add passive stamina regen

func on_armor_changed(new_armor:float):
	pass
	#override in classes if needed, maybe cool to add
	#more broken down shield/tank states 
	#based on hp

func on_armor_broken():
	pass #initate 2nd phase in enemy object

func die():
	is_dead = true
	on_death()
	emit_signal("died",coin_reward)
	VfxManager.burst(get_parent(), global_position, Color.GREEN)
	queue_free()

func on_death():
	pass #update for splitter

func on_reached_base():
	emit_signal("reached_base",damage_to_base)
	queue_free()
