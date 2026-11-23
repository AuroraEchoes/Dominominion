class_name LevelSucceededPanel extends Control

func _ready() -> void:
	var level := LocalLevelManager.get_active_level()
	level.targets_changed.connect(_on_targets_changed)
	level.cleared.connect(_on_level_cleared)

func _on_targets_changed():
	var level := LocalLevelManager.get_active_level()
	if !level.activated_civilian && level.get_targets_eliminated() >= level.get_total_targets():
		show()

func _on_level_cleared():
	hide()
