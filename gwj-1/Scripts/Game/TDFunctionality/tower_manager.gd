extends Node

var selected_tower_scene: PackedScene = null
var selected_tower_cost: int = 0
var placement_slots: Array = []

@onready var projectile_container: Node2D = $"../ProjectileContainer"
@onready var slots_container = $"../PlacementSlots"
@onready var enemy_container: Node2D = $"../EnemyContainer"
var coin_manager:Node

func _ready() -> void:
	placement_slots = slots_container.get_children()
	for slot in placement_slots:
		slot.tower_container = slots_container
		slot.bullet_container = projectile_container
		slot.enemy_container = enemy_container

func select_tower(tower_scene: PackedScene, cost: int):
	selected_tower_scene = tower_scene
	selected_tower_cost = cost

func deselect_tower():
	selected_tower_scene = null
	selected_tower_cost = 0

func _input(event: InputEvent):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index == MOUSE_BUTTON_LEFT:
		if selected_tower_scene:
			try_place_tower(get_viewport().get_mouse_position())
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
		if slot is PlacementSlot and not slot.is_occupied:
			if slot.global_position.distance_to(pos) < 10.0:
				return slot
	return null
