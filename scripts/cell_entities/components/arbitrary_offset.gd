class_name ArbitraryOffset extends RefCounted

var caller: CellEntity
var offset: Vector2i

func _init(caller: CellEntity, offset: Vector2i) -> void:
	self.caller = caller
	self.offset = offset

func get_affected_cells() -> Array[Vector2i]:
	var angle = -Vector2(caller.direction).angle_to(Vector2.UP)
	var rotated_offset = Vector2(offset).rotated(angle)
	return [caller.cell + Vector2i(round(rotated_offset.x), round(rotated_offset.y))]

func activate():
	caller.manager.activate_cells(get_affected_cells())

