extends Tower
class_name BomberTower

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_name = "Bomber"
	damage = 30.0
	range = 25.0
	fire_rate = .75
	cost = 70
	bullet_scene = preload("res://Scenes/Game/Bullets/bomber_bullet.tscn")
	bullet_speed = 90.0
	splash_radius = 30.0
	setup_upgrade_data()
	super._ready()


func setup_upgrade_data():
	upgrade_1 = UpgradeData.new()
	upgrade_1.upgrade_name = "Damage I"
	upgrade_1.description = "Increase Damage"
	upgrade_1.cost = 100
	
	upgrade_2a = UpgradeData.new()
	upgrade_2a.upgrade_name = "Rapid Fire I"
	upgrade_2a.description = "Increase Fire Rate"
	upgrade_2a.cost = 110
	
	upgrade_2b = UpgradeData.new()
	upgrade_2b.upgrade_name = "Range I"
	upgrade_2b.description = "Increase Range"
	upgrade_2b.cost = 140
	
	upgrade_3a = UpgradeData.new()
	upgrade_3a.upgrade_name = "Rapid Fire II"
	upgrade_3a.description = "Increase Fire Rate"
	upgrade_3a.cost = 150
	
	upgrade_3b = UpgradeData.new()
	upgrade_3b.upgrade_name = "Stamina I"
	upgrade_3b.description = "Increase Stamina Drain"
	upgrade_3b.cost = 165

#add upgrade functions here later
func apply_upgrade(index: int) -> void:
	match index:
		0: damage *= 1.5
		1: fire_rate *= 1.3
		2: 
			range = 40
			splash_radius *= 1.3
		3: fire_rate *= 1.5
		4: stamina_drain = 10
