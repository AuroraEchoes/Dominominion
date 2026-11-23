class_name AreaOfEffect extends Object

var caller: CellEntity
var radius: int
var affected_cells: Array[Vector2i]

func _init(caller: CellEntity, radius: int) -> void:
	self.caller = caller
	self.radius = radius
	self.affected_cells = _calculate_affected_cells()
	caller.cell_changed.connect(_on_cell_changed)

func activate():
	caller.manager.activate_cells(affected_cells)

func get_affected_cells() -> Array[Vector2i]:
	return affected_cells

func _on_cell_changed():
	self.affected_cells = _calculate_affected_cells()

func _calculate_affected_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var center := caller.cell
	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):
			var cell = Vector2i(x, y)
			if center.distance_to(cell) <= radius:
				cells.append(cell)
	return cells
