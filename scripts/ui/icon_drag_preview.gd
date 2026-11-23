class_name IconDragPreview extends Control

const SMOOTHING = 100
var texture_rect: TextureRect
var texture_global_pos: Vector2
var real_size: Vector2

func init(canvas_transform: Transform2D, icon: Texture2D, base_size: Vector2 = Vector2(64, 64)):
	real_size = base_size / canvas_transform.get_scale()
	texture_rect = TextureRect.new()
	add_child(texture_rect)
	texture_rect.texture = icon
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_rect.custom_maximum_size = real_size
	texture_rect.custom_minimum_size = real_size
	offset_transform_enabled = true
	offset_transform_position = Vector2(real_size.x * -0.5, real_size.y * -0.5)
	texture_global_pos = global_position

func _ready() -> void:
	texture_rect.global_position = global_position
	texture_global_pos = global_position

func _process(delta: float) -> void:
	var t = 1 - exp(-SMOOTHING * delta)
	texture_global_pos = lerp(texture_global_pos, global_position, t)
	texture_rect.global_position = texture_global_pos
