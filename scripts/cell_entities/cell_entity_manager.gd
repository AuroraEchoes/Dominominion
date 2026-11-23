class_name CellEntityManager extends Node

var level: Level
var cell_entities: Array[CellEntity]

func _init(level: Level) -> void:
	self.level = level
	level.simulation_started.connect(_on_simulation_started)

func register(cell_entity: CellEntity) -> void:
	cell_entities.append(cell_entity)

func unregister(cell_entity: CellEntity) -> void:
	cell_entities.erase(cell_entity)

func activate_cells(cells: Array[Vector2i]):
	for cell in cells:
		var idx := cell_entities.find_custom(_cell_entity_is_in_cell.bind(cell))
		if idx != -1:
			var cell_entity := cell_entities[idx]
			cell_entity.activate()

func _on_simulation_started():
	for cell_entity in cell_entities:
		cell_entity.prime()

func _cell_entity_is_in_cell(cell_entity: CellEntity, cell: Vector2i):
	return cell_entity.cell == cell
