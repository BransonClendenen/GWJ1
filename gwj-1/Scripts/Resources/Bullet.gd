extends Node2D
class_name Bullet

var damage: float = 0.0
var speed: float = 120.0
var splash_radius: float = 0.0
var stamina_drain: float = 0.0
var armor_pierce: float = 0.0
var target: Node2D = null
var enemies_container: Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func setup(p_damage:float,p_speed:float,p_splash:float,p_stamina:float,p_armor:float,p_target:Node2D,e_cont:Node2D):
	damage = p_damage
	speed = p_speed
	splash_radius = p_splash
	stamina_drain = p_stamina
	armor_pierce = p_armor
	target = p_target
	enemies_container = e_cont

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
	
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
	rotation = direction.angle()
	
	if global_position.distance_to(target.global_position) < 1.0:
		print("impact")
		on_impact()

func on_impact():
	if splash_radius > 0.0:
		apply_splash()
	else:
		if is_instance_valid(target) and target is Enemy:
			target.take_damage(damage,armor_pierce,stamina_drain)
	
	SfxManager.play_sfx_random([
		"res://Audio/SFX/Game/bullet_1.wav",
		"res://Audio/SFX/Game/bullet_2.wav",
		"res://Audio/SFX/Game/bullet_3.wav"])
	VfxManager.burst(get_parent(), global_position, Color.ORANGE, 6, 0.2)
	on_impact_effect()
	queue_free()

func apply_splash():
	var enemies = enemies_container.get_children()
	for enemy in enemies:
		if enemy is Enemy:
			if global_position.distance_to(enemy.global_position) <= splash_radius:
				enemy.take_damage(damage,armor_pierce,stamina_drain)
				if stamina_drain > 0.0:
					enemy.drain_stamina(stamina_drain)
					#one billion nests

func on_impact_effect():
	pass #update later for vfx or anything else interesting
