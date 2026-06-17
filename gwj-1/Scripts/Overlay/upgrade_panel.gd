extends Control

var current_tower: Node = null

@onready var slot_1: Panel = $Slot1
@onready var button_1: Button = $Slot1/Button1
@onready var slot_2a: Panel = $HBoxContainer2/Slot2a
@onready var button_2a: Button = $HBoxContainer2/Slot2a/Button2a
@onready var slot_2b: Panel = $HBoxContainer2/Slot2b
@onready var button_2b: Button = $HBoxContainer2/Slot2b/Button2b
@onready var slot_3a: Panel = $HBoxContainer/Slot3a
@onready var button_3a: Button = $HBoxContainer/Slot3a/Button3a
@onready var slot_3b: Panel = $HBoxContainer/Slot3b
@onready var button_3b: Button = $HBoxContainer/Slot3b/Button3b
@onready var upgrade_button: Button = $upgrade_button
@onready var background: ColorRect = $background

func _ready() -> void:
	#visible = false
	
	button_1.pressed.connect(on_slot_clicked.bind(0))
	button_2a.pressed.connect(on_slot_clicked.bind(1))
	button_2b.pressed.connect(on_slot_clicked.bind(2))
	button_3a.pressed.connect(on_slot_clicked.bind(3))
	button_3b.pressed.connect(on_slot_clicked.bind(4))
	upgrade_button.pressed.connect(on_upgrade_button_pressed)

func enable_panel(enabled:bool):
	background.color = Color.PURPLE if enabled else Color(0.5, 0.5, 0.5, 0.6)

func open_for_tower(tower:Node):
	current_tower = tower
	enable_panel(true)
	refresh_slots()

func close():
	visible = false
	current_tower = null

func on_slot_clicked(index:int):
	if not current_tower:
		return
	if current_tower.purchased_slots[index]:
		return
	if not current_tower.is_slot_available(index):
		return
	current_tower.selected_upgrade_index = index
	var data = current_tower.get_upgrade_data(index)
	if data:
		upgrade_button.text = "Cost-" + str(data.cost)
		upgrade_button.visible = true

func on_upgrade_button_pressed():
	if not current_tower:
		return
	current_tower.on_upgrade_button_pressed()
	refresh_slots()
	upgrade_button.visible = false

func refresh_slots():
	if not current_tower:
		return
	var slots = [slot_1, slot_2a, slot_2b, slot_3a, slot_3b]
	for i in range(slots.size()):
		if current_tower.purchased_slots[i]:
			slots[i].modulate = Color(0.2, 0.8, 0.2)
		elif not current_tower.is_slot_available(i):
			slots[i].modulate = Color(0.4, 0.4, 0.4)
		else:
			slots[i].modulate = Color.WHITE

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if not visible:
			return
		if not get_rect().has_point(get_local_mouse_position()):
			pass
			#close()
