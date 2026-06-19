extends Enemy
class_name MiniEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Mini"
	max_hp = 10
	max_stamina = 0
	max_armor = 0
	speed = 50
	coin_reward = 0
	damage_to_base = 1
	super._ready()
