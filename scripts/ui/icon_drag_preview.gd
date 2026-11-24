class_name IconDragPreview extends TextureRect

func init(canvas_transform: Transform2D, icon: Texture2D, base_size: Vector2 = Vector2(64, 64)):
	var real_size := base_size / canvas_transform.get_scale()
	texture = icon
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	custom_maximum_size = real_size
	custom_minimum_size = real_size
	offset_transform_enabled = true
	offset_transform_position = Vector2(real_size.x * -0.5, real_size.y * -0.5)
