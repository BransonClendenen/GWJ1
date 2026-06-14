extends Resource
class_name LevelData

@export var level_name: String = ""
@export var path_curve: Curve2D
@export var waves: Array[WaveData] = []
@export var avaliable_towers: Array[PackedScene] = []
@export var starting_coins: int = 100
@export var base_hp: int = 10
