class_name CellEntityAudioPlayer extends AudioStreamPlayer

@export var cell_entity: CellEntity

@export var enter_active_sounds: AudioStreamRandomizer
@export var exit_active_sounds: AudioStreamRandomizer

func _ready() -> void:
	cell_entity.entered_active.connect(_on_enter_active)
	cell_entity.exited_active.connect(_on_exit_active)

func _on_enter_active():
	if enter_active_sounds != null:
		stream = enter_active_sounds
		play()

func _on_exit_active():
	if exit_active_sounds != null:
		stream = exit_active_sounds
		play()
