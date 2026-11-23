class_name ItemShake extends Object

func _init(node: Control, duration: float, strength: float, speed: float) -> void:
	var base_pos = node.position
	var tween = node.create_tween()
	var shakes = speed * 100 * duration
	var shake_duration = duration / shakes
	for i in shakes:
		var end := Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
		tween.tween_property(node, "position", base_pos + end, shake_duration)
	tween.tween_property(node, "position", base_pos, shake_duration)
