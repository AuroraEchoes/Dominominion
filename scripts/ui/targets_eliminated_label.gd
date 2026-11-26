extends Label

func _ready() -> void:
	LocalLevelManager.get_active_level().targets_changed.connect(_update_label)
	_update_label()

func _update_label():
	var level = LocalLevelManager.get_active_level()
	text = "Treasure Gathered: %s/%s" % [str(level.get_targets_eliminated()), str(level.get_total_targets())]
