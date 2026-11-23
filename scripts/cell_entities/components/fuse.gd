class_name Fuse extends Object

signal finished

const SHAKE_STRENGTH: float = 1
const SHAKE_SPEED: float = 0.5

func _init(caller: Control, length: float) -> void:
	ItemShake.new(caller, length, SHAKE_STRENGTH, SHAKE_SPEED)
	var timer = caller.get_tree().create_timer(length)
	timer.timeout.connect(_on_timeout)

func _on_timeout():
	finished.emit()
