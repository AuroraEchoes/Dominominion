class_name ArbitraryOffset extends Object

var caller: CellEntity
var offset: Vector2i

func _init(caller: CellEntity, offset: Vector2i) -> void:
	self.caller = caller
	self.offset = offset

func get_affected_cells() -> Array[Vector2i]:
	return [caller.cell + Vector2i(Vector2(offset).rotated(-Vector2(caller.direction).angle_to(Vector2.UP)))]

func activate():
	caller.manager.activate_cells(get_affected_cells())

