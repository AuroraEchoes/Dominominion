class_name CellEntityManager extends Node

var level: Level
var cell_entities: Array[CellEntity]

func _init(level: Level) -> void:
	self.level = level

func register(cell_entity: CellEntity):
	pass
