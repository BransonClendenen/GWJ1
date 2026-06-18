extends Tower
class_name GunnerTower

func _ready():
	tower_name = "Gunner"
	damage = 15.0
	range = 50.0
	fire_rate = 1.5
	cost = 60
	bullet_scene = preload("res://Scenes/Game/Bullets/gunner_bullet.tscn")
	bullet_speed = 140.0
	stamina_drain = 10
	setup_upgrade_data()
	super._ready()


func setup_upgrade_data():
	upgrade_1 = UpgradeData.new()
	upgrade_1.upgrade_name = "Rapid Fire I"
	upgrade_1.description = "Increase Fire Rate"
	upgrade_1.cost = 60
	
	upgrade_2a = UpgradeData.new()
	upgrade_2a.upgrade_name = "Rapid Fire II"
	upgrade_2a.description = "Increase Fire Rate"
	upgrade_2a.cost = 80
	
	upgrade_2b = UpgradeData.new()
	upgrade_2b.upgrade_name = "Stamina I"
	upgrade_2b.description = "Increase Stamina Drain"
	upgrade_2b.cost = 100
	
	upgrade_3a = UpgradeData.new()
	upgrade_3a.upgrade_name = "Rapid Fire III"
	upgrade_3a.description = "Increase Fire Rate"
	upgrade_3a.cost = 90
	
	upgrade_3b = UpgradeData.new()
	upgrade_3b.upgrade_name = "High Caliber"
	upgrade_3b.description = "Increase Damage, Decrease Fire Rate"
	upgrade_3b.cost = 100

#add upgrade functions here later
func apply_upgrade(index: int) -> void:
	match index:
		0: fire_rate *= 1.3
		1: fire_rate *= 1.5
		2: stamina_drain *= 1.5
		3: fire_rate *= 2.0
		4: 
			damage *= 1.5
			fire_rate *= 0.5
