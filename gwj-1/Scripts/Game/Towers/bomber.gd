extends Tower
class_name BomberTower


# Called when the node enters the scene tree for the first time.
func _ready():
	tower_name = "Bomber"
	damage = 30.0
	range = 27.0
	fire_rate = .75
	cost = 70
	bullet_scene = preload("res://Scenes/Game/Bullets/bomber_bullet.tscn")
	bullet_speed = 90.0
	splash_radius = 50.0
	super._ready()
