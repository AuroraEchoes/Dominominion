class_name Charge extends RefCounted

signal finished

func _init(caller: CellEntity, cells: Array[Vector2i], speed: float) -> void:
	var end_cell: Vector2i
	if cells.size() > 1:
		end_cell = cells[cells.size() - 2]
	else:
		end_cell = cells[0]
	var delta_map = end_cell - caller.cell
	var time = delta_map.length() / speed
	var delta_world := Vector2(caller.manager.level.terrain.tile_set.tile_size) * Vector2(delta_map)
	var tween := caller.create_tween()
	tween.tween_property(caller, "offset_transform_position", delta_world, time)
	tween.finished.connect(_on_finished)

func _on_finished():
	finished.emit()
