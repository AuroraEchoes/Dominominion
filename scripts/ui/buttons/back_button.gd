class_name BackButton extends Button

@export var panel_to_hide: Control

func _pressed() -> void:
	panel_to_hide.hide()
