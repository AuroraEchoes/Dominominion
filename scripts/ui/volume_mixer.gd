extends HSlider

@export var audio_bus_name: String

var bus_idx: int

func _ready() -> void:
	bus_idx = AudioServer.get_bus_index(audio_bus_name)
	var current_volume := AudioServer.get_bus_volume_linear(bus_idx)
	set_value_no_signal(current_volume)

func _value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_linear(bus_idx, new_value)
