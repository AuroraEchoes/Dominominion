class_name InventoryButtonController extends Control

@export var dormant_button_container: Container
@export var simulating_button_container: Container

func _ready():
	var level := LocalLevelManager.get_active_level()
	level.state_changed.connect(_update_button_visibilty)
	_update_button_visibilty()

func _update_button_visibilty():
	var level := LocalLevelManager.get_active_level()
	if level.state == Level.LevelState.DORMANT:
		dormant_button_container.show()
		simulating_button_container.hide()
	elif level.state == Level.LevelState.SIMULATING:
		dormant_button_container.hide()
		simulating_button_container.show()
