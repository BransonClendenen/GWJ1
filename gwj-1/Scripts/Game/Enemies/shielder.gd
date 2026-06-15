extends Enemy
class_name ShielderEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Shielder"
	max_hp = 100
	max_stamina = 0
	max_armor = 100
	speed = 8
	coin_reward = 5
	damage_to_base = 10
	super._ready()
