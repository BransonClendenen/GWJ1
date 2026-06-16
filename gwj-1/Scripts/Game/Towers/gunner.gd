extends Tower
class_name GunnerTower

func _ready():
	tower_name = "Gunner"
	damage = 15.0
	range = 300.0
	fire_rate = 1.5
	cost = 60
	bullet_scene = preload("res://Scenes/Game/Bullets/gunner_bullet.tscn")
	bullet_speed = 140.0
	stamina_drain = 10
	super._ready()

#add upgrade functions here later
