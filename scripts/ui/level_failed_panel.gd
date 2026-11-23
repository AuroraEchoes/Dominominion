class_name LevelFailedPanel extends Control

func _ready() -> void:
	var level := LocalLevelManager.get_active_level()
	level.civilian_activated.connect(_on_civilian_activated)
	level.cleared.connect(_on_level_cleared)

func _on_civilian_activated():
	show()

func _on_level_cleared():
	hide()
