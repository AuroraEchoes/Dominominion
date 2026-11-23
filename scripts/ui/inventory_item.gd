extends Control
class_name InventoryItem

var item_resource: String
var item_count: int
@export var item_name_label: Label
@export var item_texture_rect: TextureRect

func init(item: String, count: int):
	item_resource = item
	item_count = count
	_update_label()
	_update_texture()

func set_count(count: int):
	item_count = count
	_update_label()

func _ready() -> void:
	if item_resource != null and item_resource != "":
		_update_label()
		_update_texture()

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(_get_drag_preview())
	return item_resource

func _get_drag_preview() -> Control:
	var preview := IconDragPreview.new()
	preview.init(ItemManager.get_item(item_resource).get_item_texture())
	return preview

func _update_label():
	item_name_label.text = "%s (%s)" % [ItemManager.get_item(item_resource).get_item_name(), str(item_count)]

func _update_texture():
	item_texture_rect.texture = ItemManager.get_item(item_resource).get_item_texture()
