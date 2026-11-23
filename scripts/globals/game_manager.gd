extends Node

var main_menu_scene: PackedScene = preload("res://scenes/ui/MainMenu.tscn")
var game_scene: PackedScene = preload("res://scenes/Game.tscn")

var current_root: Node

func _ready() -> void:
	current_root = get_node("/root/MainMenu")

func load_main_menu():
	var scene := main_menu_scene.instantiate()
	get_tree().root.add_child(scene)
	current_root.queue_free()
	current_root = scene

func load_level(level: PackedScene):
	LocalLevelManager.set_level_scene(level)
	var scene := game_scene.instantiate()
	get_tree().root.add_child(scene)
	current_root.queue_free()
	current_root = scene
