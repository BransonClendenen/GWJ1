extends Node2D
class_name Enemy

@export var enemy_name: String
@export var max_hp: float
@export var max_stamina: float
@export var speed: float
@export var coin_reward: int
@export var damage_to_base: int

var current_hp: float
var current_stamina: float
var is_dead: bool = false

var path_points: PackedVector2Array = []
var path_index: int = 0

@onready var sprite: Sprite2D = $sprite
@onready var bgbar: ColorRect = $hpbar/bgbar
@onready var fillbar: ColorRect = $hpbar/fillbar

signal died(reward:int)
signal reached_base(damage:int)

func _ready():
	current_hp = max_hp

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

func take_damage(amount:float):
	if is_dead:
		return
	current_hp -= amount
	VfxManager.flash(self)
	update_hp_bar()
	on_hit()
	if current_hp <= 0:
		die()

func on_hit():
	pass #update later for dodge

func update_hp_bar() -> void:
	fillbar.size.x = bgbar.size.x * (current_hp / max_hp)

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
