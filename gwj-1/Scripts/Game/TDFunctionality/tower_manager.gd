extends Node

var selected_tower_scene: PackedScene = null
var selected_tower_cost: int = 0
var placement_slots: Array = []

var ghost_sprite: Sprite2D = null

@onready var projectile_container: Node2D = $"../ProjectileContainer"
@onready var slots_container = $"../PlacementSlots"
@onready var enemy_container: Node2D = $"../EnemyContainer"
@onready var coin_manager: Node = $"../CoinManager"
@onready var tower_container: Node2D = $"../TowerContainer"

func _ready() -> void:
	pass

func refresh_slots():
	placement_slots.clear()
	var wrappers = slots_container.get_children()
	for wrapper in wrappers:
		for slot in wrapper.get_children():
			if slot is PlacementSlot:
				placement_slots.append(slot)
				slot.tower_container = tower_container
				slot.bullet_container = projectile_container
				slot.enemy_container = enemy_container
				slot.coin_manager = coin_manager

func _process(delta: float) -> void:
	if ghost_sprite:
		ghost_sprite.global_position = ghost_sprite.get_global_mouse_position()

func select_tower(tower_scene: PackedScene, cost: int,preview_texture: Texture2D):
	selected_tower_scene = tower_scene
	selected_tower_cost = cost
	show_ghost(preview_texture)

func deselect_tower():
	selected_tower_scene = null
	selected_tower_cost = 0
	hide_ghost()

func show_ghost(texture: Texture2D):
	if ghost_sprite:
		ghost_sprite.queue_free()
	ghost_sprite = Sprite2D.new()
	ghost_sprite.texture = texture
	ghost_sprite.modulate = Color(1, 1, 1, 0.5)
	ghost_sprite.scale = Vector2(0.39, 0.39)
	get_tree().current_scene.get_node("GameLayer/TDMap").add_child(ghost_sprite)

func hide_ghost():
	if ghost_sprite:
		ghost_sprite.queue_free()
		ghost_sprite = null

func _input(event: InputEvent):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		if selected_tower_scene:
			try_place_tower(get_viewport().get_mouse_position())
			get_viewport().set_input_as_handled()
	if event.button_index == MOUSE_BUTTON_RIGHT:
		deselect_tower()

func try_place_tower(mouse_pos: Vector2):
	var slot = get_slot_at(mouse_pos)
	if slot == null:
		return
	if not coin_manager.can_afford(selected_tower_cost):
		return
	
	var placed = slot.place_tower(selected_tower_scene)
	if placed:
		coin_manager.spend_coins(selected_tower_cost)
		deselect_tower()
		#SfxManager.play_sfx("some nonsense")

func get_slot_at(pos:Vector2) -> PlacementSlot:
	for slot in placement_slots:
		print("checking slot at ", slot.global_position, " occupied: ", slot.is_occupied)
		if slot is PlacementSlot and not slot.is_occupied:
			if slot.global_position.distance_to(pos) < 10.0:
				return slot
	return null
