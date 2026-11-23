extends TextureRect
class_name IconDragPreview

func init(icon: Texture2D):
	texture = icon
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	custom_maximum_size = Vector2(64, 64)
	custom_minimum_size = Vector2(64, 64)
	offset_transform_enabled = true
	offset_transform_position = Vector2(-32, -32)
