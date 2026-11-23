class_name ResetButton extends Button

func _pressed() -> void:
	LocalLevelManager.get_active_level().clear()

func _get_tooltip(at_position: Vector2) -> String:
	return "Retry Level"
