extends Enemy
class_name SplitterEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Splitter"
	max_hp = 20
	max_stamina = 0
	max_armor = 0
	speed = 25
	coin_reward = 2
	damage_to_base = 5
	super._ready()
