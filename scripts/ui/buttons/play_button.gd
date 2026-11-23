extends Button

func _pressed() -> void:
	LocalLevelManager.get_active_level().simulate()

func _get_tooltip(at_position: Vector2) -> String:
	return "Play"
