extends Resource
class_name ItemEffectResource

enum AreaType {
	CIRCLE
}

@export var area_type: AreaType
@export var area_value: int

func get_affected_cells(center: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	if area_type == AreaType.CIRCLE:
		var radius = area_value
		for x in range(center.x - radius, center.x + radius + 1):
			for y in range(center.y - radius, center.y + radius + 1):
				var cell = Vector2i(x, y)
				if center.distance_to(cell) <= radius:
					cells.append(cell)
	return cells
