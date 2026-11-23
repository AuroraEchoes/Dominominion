class_name CellEntityManager extends Node

signal any_changed

var level: Level
var cell_entities: Array[CellEntity]

func _init(level: Level) -> void:
	self.level = level
	level.simulation_started.connect(_on_simulation_started)

func clear():
	for entity in cell_entities.duplicate():
		if entity.resource.pickable:
			entity.destroy()

func register(cell_entity: CellEntity) -> void:
	cell_entities.append(cell_entity)
	cell_entity.cell_changed.connect(_on_cell_changed)
	any_changed.emit()

func unregister(cell_entity: CellEntity) -> void:
	var index := cell_entities.find_custom(_cell_entity_is_in_cell.bind(cell_entity.cell))
	if index != -1:
		cell_entity.cell_changed.disconnect(_on_cell_changed)
		cell_entities.remove_at(index)
	else:
		print("Tried to unregister a cell which already doesn’t exist?")
	any_changed.emit()

func make_all_cells_dormant():
	for cell in cell_entities:
		cell.dormant()
	any_changed.emit()

func activate_cells(cells: Array[Vector2i]):
	for cell in cells:
		var idx := cell_entities.find_custom(_cell_entity_is_in_cell.bind(cell))
		if idx != -1:
			var cell_entity := cell_entities[idx]
			cell_entity.activate()
	any_changed.emit()

func is_cell_filled(cell: Vector2i) -> bool:
	var index := cell_entities.find_custom(_cell_entity_is_in_cell.bind(cell))
	return index != -1

func _on_simulation_started():
	for cell_entity in cell_entities:
		cell_entity.prime()

func _cell_entity_is_in_cell(cell_entity: CellEntity, cell: Vector2i):
	return cell_entity.cell == cell

func _on_cell_changed():
	any_changed.emit()
