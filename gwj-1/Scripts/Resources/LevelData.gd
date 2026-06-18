extends Resource
class_name LevelData

@export var level_name: String = ""
@export var path_curve: Curve2D
@export var tilemap_scene: PackedScene
@export var placement_slots_scene: PackedScene
@export var waves: Array[WaveData] = []
@export var avaliable_towers: Array[PackedScene] = []
@export var starting_coins: int = 100
@export var base_hp: int = 10
@export var wave_delay: float = 10.0
