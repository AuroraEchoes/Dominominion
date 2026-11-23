class_name Fuse extends Object

const SHAKE_STRENGTH: float = 1
const SHAKE_SPEED: float = 0.5

func _init(caller: Node2D, length: float) -> void:
	var item_shake = ItemShake.new(caller, length, SHAKE_STRENGTH, SHAKE_SPEED)
	var timer = caller.get_tree().create_timer(length)
	await timer.timeout
