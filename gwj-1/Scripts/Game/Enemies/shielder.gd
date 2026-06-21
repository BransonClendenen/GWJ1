extends Enemy
class_name ShielderEnemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Shielder"
	max_hp = 200
	max_stamina = 0
	max_armor = 250
	armor_reduction = 0.75
	speed = 8
	coin_reward = 1
	damage_to_base = 10
	super._ready()

func on_armor_broken():
	speed = 30
	damage_to_base = 2
	sprite.play("shield_broken")
	sprite.animation_finished.connect(_on_transition_finished, CONNECT_ONE_SHOT)
	#when we get sprites
	#sprite.texture = load("res://Assets/Sprites/enemy_shielder_phase2.png")
	VfxManager.burst(get_parent(), global_position, Color.ORANGE, 16, 0.4)
	VfxManager.flash(self, Color.ORANGE)

func _on_transition_finished():
	sprite.play("phase2")
