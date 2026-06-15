extends Enemy
class_name TurtlerEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Turtler"
	max_hp = 400
	max_stamina = 200
	max_armor = 200
	speed = 10
	coin_reward = 100
	damage_to_base = 100
	super._ready()
