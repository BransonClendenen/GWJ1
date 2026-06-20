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
@export var armor_pierce: float

@export var upgrade_1: UpgradeData
@export var upgrade_2a: UpgradeData
@export var upgrade_2b: UpgradeData
@export var upgrade_3a: UpgradeData
@export var upgrade_3b: UpgradeData

var fire_timer: float = 0.0
var current_target: Node2D = null
var enemies_in_range: Array = []
var projectile_container: Node2D
var enemies_container: Node2D
var upgrade_level: int = 0
var chosen_branch: int = 0
var purchased_slots: Array = [false,false,false,false,false]
#0=slot1, 1=slot2A, 2=slot2B, 3=slot3A, 4=slot3B
var selected_upgrade_index: int = -1

@onready var coin_manager: CoinManager = get_tree().current_scene.get_node("GameLayer/TDMap/CoinManager")

@onready var range_area: Area2D = $RangeArea
@onready var range_shape: CollisionShape2D = $RangeArea/CollisionShape2D
@onready var base_sprite: Sprite2D = $base_sprite
@onready var barrel_sprite: Sprite2D = $barrel_sprite
@onready var shoot_point: Marker2D = $barrel_sprite/ShootPoint

func _ready():
	setup_range()
	range_area.area_entered.connect(_on_area_entered)
	range_area.area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	fire_timer += delta
	update_target()
	rotate_barrel(delta)
	if current_target and fire_timer >= 1.0 / fire_rate:
		fire_timer = 0.0
		shoot()

func rotate_barrel(delta:float):
	if not current_target:
		return
	var direction = (current_target.global_position - barrel_sprite.global_position).normalized()
	var target_angle = direction.angle()
	barrel_sprite.rotation = lerp_angle(barrel_sprite.rotation, target_angle, delta * 10.0)

func update_target():
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	if enemies_in_range.is_empty():
		current_target = null
		return
	
	var best = enemies_in_range[0]
	for e in enemies_in_range:
		if e.path_index > best.path_index:
			best = e
	current_target = best

func _on_area_entered(body:Node2D):
	if body.get_parent() is Enemy:
		enemies_in_range.append(body.get_parent())

func _on_area_exited(body:Node2D):
	enemies_in_range.erase(body.get_parent())

func shoot():
	if not bullet_scene or not current_target:
		return
	var bullet = bullet_scene.instantiate()
	projectile_container.add_child(bullet)
	bullet.global_position = shoot_point.global_position
	bullet.setup(damage,bullet_speed,splash_radius,stamina_drain,armor_pierce,current_target,enemies_container)
	SfxManager.play_sfx_pitched("res://Audio/SFX/Game/sfx_tower_fire.wav")

func setup_range():
	var shape = CircleShape2D.new()
	shape.radius = range
	range_shape.shape = shape

func can_afford(coins:int):
	return coins >= cost

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = get_global_mouse_position()
			if global_position.distance_to(mouse_pos) <= 32.0:
				var upgrade_ui = GameState.upgrade_panel
				upgrade_ui.open_for_tower(self)
				set_selected_visual(true)
				get_viewport().set_input_as_handled()

func set_selected_visual(selected: bool) -> void:
	modulate = Color(1.5, 1.5, 1.5) if selected else Color.WHITE

func is_slot_available(index:int) -> bool:
	match index:
		0:
			return not purchased_slots[0]
		1:
			return purchased_slots[0] and chosen_branch != 2
		2:
			return purchased_slots[0] and chosen_branch != 1
		3:
			return purchased_slots[1]
		4:
			return purchased_slots[2]
	return false

func get_upgrade_data(index:int) -> UpgradeData:
	match index:
		0: return upgrade_1
		1: return upgrade_2a
		2: return upgrade_2b
		3: return upgrade_3a
		4: return upgrade_3b
	return null

func on_upgrade_button_pressed():
	if selected_upgrade_index == -1:
		return
	
	var data = get_upgrade_data(selected_upgrade_index)
	if not data:
		return
	if not coin_manager.can_afford(data.cost):
		SfxManager.play_sfx("res://Audio/SFX/UI/sfx_cant_afford.ogg")
		return
	
	coin_manager.spend_coins(data.cost)
	purchased_slots[selected_upgrade_index] = true
	
	match selected_upgrade_index:
		1: chosen_branch = 1
		2: chosen_branch = 2
	
	apply_upgrade(selected_upgrade_index)
	SfxManager.play_sfx("res://Audio/SFX/UI/sfx_upgrade_bought.ogg")
	selected_upgrade_index = -1

func apply_upgrade(index: int) -> void:
	pass #override
