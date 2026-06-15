extends Tower
class_name SniperTower


# Called when the node enters the scene tree for the first time.
func _ready():
	tower_name = "Sniper"
	damage = 60.0
	range = 100.0
	fire_rate = .50
	cost = 180
	bullet_speed = 200.0
	armor_pierce = 10.0
	super._ready()
