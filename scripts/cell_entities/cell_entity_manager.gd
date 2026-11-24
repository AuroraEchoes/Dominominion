class_name CellEntityManager extends Node

signal any_changed

const PLACEABLE_CELL_ATLAS_INDEX: int = 1
const PLACEABLE_CELL_ATLAS_POSITION: Vector2i = Vector2i(1, 1)

var level: Level
var cells_entities: Dictionary[Vector2i, CellEntity]
var pre_razed_terrain_values: Dictionary[Vector2i, PreRazedCellData] = {}

func _init(level: Level) -> void:
	self.level = level
	level.simulation_started.connect(_on_simulation_started)

func clear():
	for cell in cells_entities.keys():
		if cells_entities[cell].resource.pickable:
			cells_entities[cell].destroy()
			cells_entities.erase(cell)

func register(cell_entity: CellEntity) -> void:
	cells_entities.set(cell_entity.cell, cell_entity)
	cell_entity.cell_changed.connect(_on_cell_changed)
	any_changed.emit()

func unregister(cell_entity: CellEntity, erase: bool = false) -> void:
	cell_entity.cell_changed.disconnect(_on_cell_changed)
	cells_entities.erase(cell_entity.cell)
	# cell_entities.erase(cell_entity)
	any_changed.emit()

func change_cell(previous_cell: Vector2i, new_cell: Vector2i):
	cells_entities[new_cell] = cells_entities[previous_cell]
	cells_entities.erase(previous_cell)

func make_all_cells_dormant():
	for cell in cells_entities:
		cells_entities[cell].dormant()
	for cell in pre_razed_terrain_values:
		level.terrain.set_cell(cell, pre_razed_terrain_values[cell].atlas_id, pre_razed_terrain_values[cell].atlas_cell)
	any_changed.emit()

func activate_cells(cells: Array[Vector2i]):
	for cell in cells:
		if cells_entities.has(cell):
			cells_entities[cell].activate()
		raze_terrain_cell_if_occupied(cell)
		
	any_changed.emit()

func is_cell_filled(cell: Vector2i) -> bool:
	return cells_entities.has(cell)

func raze_terrain_cell_if_occupied(cell: Vector2i):
	var terrain_data := level.terrain.get_cell_tile_data(cell)
	var placeable := false
	if terrain_data != null:
		placeable = terrain_data.get_custom_data("placeable")
		var replaceable := terrain_data.get_custom_data("replaceable") as bool
		if !placeable && replaceable:
			var atlas_id := level.terrain.get_cell_source_id(cell)
			var atlas_cell := level.terrain.get_cell_atlas_coords(cell)
			pre_razed_terrain_values[cell] = PreRazedCellData.new(atlas_id, atlas_cell)
			level.terrain.set_cell(cell, PLACEABLE_CELL_ATLAS_INDEX, PLACEABLE_CELL_ATLAS_POSITION)
	any_changed.emit()


func _on_simulation_started():
	for cell in cells_entities:
		if cells_entities[cell] != null:
			cells_entities[cell].prime()
		else:
			print("removing to be safe but this is a problem")
			cells_entities.erase(cell)

func _on_cell_changed():
	any_changed.emit()

class PreRazedCellData:
	var atlas_id: int
	var atlas_cell: Vector2i

	func _init(atlas_id: int, atlas_cell: Vector2i) -> void:
		self.atlas_id = atlas_id
		self.atlas_cell = atlas_cell
