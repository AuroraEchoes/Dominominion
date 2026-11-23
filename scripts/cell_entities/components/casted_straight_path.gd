class_name CastedStraightPath extends Object

var caller: CellEntity
var max_dist: int
var affected_cells: Array[Vector2i]

func _init(caller: CellEntity, max_dist: int = 10) -> void:
	self.caller = caller
	self.max_dist = max_dist
	self.affected_cells = _calculate_affected_cells()
	caller.cell_changed.connect(_on_cell_changed)
	caller.direction_changed.connect(_on_cell_changed)
	caller.manager.any_changed.connect(_on_cell_changed)

func get_affected_cells() -> Array[Vector2i]:
	return affected_cells

func activate():
	caller.manager.activate_cells(affected_cells)

func _on_cell_changed():
	self.affected_cells = _calculate_affected_cells()

func _calculate_affected_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var center := caller.cell
	var hit_something := false
	var current_cell := center
	while cells.size() < max_dist && !hit_something:
		cells.append(current_cell)
		if caller.manager.level.is_cell_occupied(current_cell) && current_cell != caller.cell:
			hit_something = true
		current_cell += caller.direction
	return cells
