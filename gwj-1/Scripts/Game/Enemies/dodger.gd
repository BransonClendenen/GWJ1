extends Enemy
class_name DodgerEnemy

@export var stamina_regen: float = 2.0
var stamina_depleted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_name = "Dodger"
	max_hp = 20
	max_stamina = 60
	max_armor = 0
	speed = 15
	coin_reward = 1
	damage_to_base = 2
	super._ready()

func _process(delta: float) -> void:
	if is_dead:
		return
	if not stamina_depleted and current_stamina < max_stamina:
		restore_stamina(stamina_regen * delta)
	super._process(delta)

func on_stamina_changed(new_stamina: float) -> void:
	if new_stamina <= 0.0:
		stamina_depleted = true
