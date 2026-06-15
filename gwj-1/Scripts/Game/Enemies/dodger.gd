extends Enemy
class_name DodgerEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Dodger"
	max_hp = 10
	max_stamina = 10
	max_armor = 0
	speed = 50
	coin_reward = 50
	damage_to_base = 2
	super._ready()
