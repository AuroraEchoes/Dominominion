class_name SettingsButton extends Button

@export var settings_panel: Control

func _pressed() -> void:
	if settings_panel != null:
		settings_panel.show()
	else:
		print("settings button null!?")
