extends Enemy
class_name ShielderEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Shielder"
	max_hp = 100
	max_stamina = 0
	max_armor = 100
	armor_reduction = 0.5
	speed = 8
	coin_reward = 5
	damage_to_base = 10
	super._ready()

func on_armor_broken():
	speed = 20
	damage_to_base = 2
	#when we get sprites
	#sprite.texture = load("res://Assets/Sprites/enemy_shielder_phase2.png")
	VfxManager.burst(get_parent(), global_position, Color.ORANGE, 16, 0.4)
	VfxManager.flash(self, Color.ORANGE)
