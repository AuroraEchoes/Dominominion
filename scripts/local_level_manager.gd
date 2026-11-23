extends Node

var _active_level: Level
var _scene: PackedScene

func set_level_scene(scene: PackedScene):
	_scene = scene

func set_active_level(level: Level):
	_active_level = level

func get_active_level() -> Level:
	if _active_level == null:
		var level := _scene.instantiate() as Level
		get_tree().root.get_node("Game").add_child.call_deferred(level)
		set_active_level(level)
	return _active_level
