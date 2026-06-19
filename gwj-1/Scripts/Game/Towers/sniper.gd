extends Tower
class_name SniperTower

# Called when the node enters the scene tree for the first time.
func _ready():
	tower_name = "Sniper"
	damage = 60.0
	range = 100.0
	fire_rate = .50
	cost = 80
	bullet_scene = preload("res://Scenes/Game/Bullets/sniper_bullet.tscn")
	bullet_speed = 200.0
	armor_pierce = 0.5
	stamina_drain = 0.0
	setup_upgrade_data()
	super._ready()


func setup_upgrade_data():
	upgrade_1 = UpgradeData.new()
	upgrade_1.upgrade_name = "Damage I"
	upgrade_1.description = "Increase Damage"
	upgrade_1.cost = 95
	
	upgrade_2a = UpgradeData.new()
	upgrade_2a.upgrade_name = "Damage II"
	upgrade_2a.description = "Increase Damage"
	upgrade_2a.cost = 125
	
	upgrade_2b = UpgradeData.new()
	upgrade_2b.upgrade_name = "Range"
	upgrade_2b.description = "Increase Range"
	upgrade_2b.cost = 115
	
	upgrade_3a = UpgradeData.new()
	upgrade_3a.upgrade_name = "Armor Pen I"
	upgrade_3a.description = "Increase Armor Pen"
	upgrade_3a.cost = 215
	
	upgrade_3b = UpgradeData.new()
	upgrade_3b.upgrade_name = "Explosive Rounds"
	upgrade_3b.description = "Adds Splash Damage, Decrease Fire Rate"
	upgrade_3b.cost = 165

#add upgrade functions here later
func apply_upgrade(index: int) -> void:
	match index:
		0: damage *= 1.3
		1: damage *= 1.3
		2: range = 150
		3: armor_pierce = 1.0
		4: 
			splash_radius = 10.0
			fire_rate *= 0.8
