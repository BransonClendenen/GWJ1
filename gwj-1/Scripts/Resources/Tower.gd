extends Node2D
class_name Tower

@export var tower_name: String
@export var damage: float
@export var range: float
@export var fire_rate: float
@export var cost: int
@export var bullet_scene: PackedScene
@export var bullet_speed: float
@export var splash_radius: float
@export var stamina_drain: float

var fire_timer: float = 0.0
var current_target: Node2D = null
var enemies_in_range: Array = []
var projectile_container: Node2D

@onready var range_area: Area2D = $RangeArea
@onready var range_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var shoot_point: Marker2D = $ShootPoint

func _ready():
	setup_range()
	range_area.body_entered.connect(_on_body_entered)
	range_area.body_exited.connect(_on_body_exited)
	

func _process(delta: float) -> void:
	fire_timer += delta
	update_target()
	if current_target and fire_timer >= 1.0 / fire_rate:
		fire_timer = 0.0
		shoot()

func update_target():
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	current_target = enemies_in_range[0] if not enemies_in_range.is_empty() else null

func _on_body_entered(body:Node2D):
	if body is Enemy:
		enemies_in_range.append(body)

func _on_body_exited(body:Node2D):
	enemies_in_range.erase(body)

func shoot():
	if not bullet_scene or not current_target:
		return
	var bullet = bullet_scene.instantiate()
	projectile_container.add_child(bullet)
	bullet.global_position = shoot_point.global_position
	bullet.setup(damage,bullet_speed,splash_radius,stamina_drain,current_target)

func setup_range():
	var shape = CircleShape2D.new()
	shape.radius = range
	range_shape.shape = shape

func can_afford(coins:int):
	return coins >= cost
