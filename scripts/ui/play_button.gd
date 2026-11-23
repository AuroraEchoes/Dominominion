extends Button

func _pressed() -> void:
	LocalLevelManager.get_active_level().simulate()
