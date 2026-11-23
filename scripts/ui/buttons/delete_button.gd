class_name DeleteButton extends Button

func _pressed() -> void:
	LocalLevelManager.get_active_level().reset()

func _get_tooltip(at_position: Vector2) -> String:
	return "Delete All Progress"
