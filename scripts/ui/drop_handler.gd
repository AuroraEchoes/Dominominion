extends Control

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var level: Level = LocalLevelManager.get_active_level()
	var global_pos = to_global(at_position)
	var can_drop := level.can_drop_at_global_pos(global_pos)
	return can_drop

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var level: Level = LocalLevelManager.get_active_level()
	var global_pos = to_global(at_position)
	level.drop_at_global_pos(global_pos, data as String)

func to_global(local: Vector2) -> Vector2:
	return get_screen_transform() * get_global_transform_with_canvas() * local
