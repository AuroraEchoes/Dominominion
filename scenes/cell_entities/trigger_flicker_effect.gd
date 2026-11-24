extends TextureRect

@export var parent: TextureRect
@export var frames: Array[Texture2D]
@export var time_per_frame: float

@export var min_radius: float
@export var max_radius: float
@export var min_radius_time: float
@export var max_radius_time: float

var time_since_frame_change: float = 0

func _ready() -> void:
	start_radius_tween()

func _process(delta: float) -> void:
	time_since_frame_change += delta
	if time_since_frame_change >= time_per_frame:
		var next_index = randi_range(0, frames.size() - 1)
		parent.texture = frames[next_index]
		time_since_frame_change = 0.0

func start_radius_tween():
	var tween := create_tween()
	for i in range(100):
		var duration := randf_range(min_radius_time, max_radius_time)
		var radius := randf_range(min_radius, max_radius)
		tween.tween_property(texture as GradientTexture2D, "fill_to", Vector2(radius, 0.0), duration)
	tween.finished.connect(start_radius_tween)
