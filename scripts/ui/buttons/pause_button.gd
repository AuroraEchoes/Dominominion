class_name PauseButton extends Button

@export var texture_rect: TextureRect
@export var pause_icon: Texture2D
@export var play_button: Texture2D

var current_state: bool = false

func _ready() -> void:
	LocalLevelManager.get_active_level().pause_state_changed.connect(_on_pause_state_changed)

func _pressed() -> void:
	if current_state:
		LocalLevelManager.get_active_level().unpause()
		current_state = false
	else:
		LocalLevelManager.get_active_level().pause()
		current_state = true
	_on_pause_state_changed(current_state)


func _on_pause_state_changed(new_state: bool):
	current_state = new_state
	if current_state:
		texture_rect.texture = play_button
	else:
		texture_rect.texture = pause_icon
