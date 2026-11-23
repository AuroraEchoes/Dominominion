class_name Tooltip extends Control

@export var item_texture_rect: TextureRect
@export var item_name_label: Label
@export var item_description_label: RichTextLabel
@export var tooltip_icon_packed_scene: PackedScene
@export var icon_container: Container

func initialize(resource: ItemResource):
	item_texture_rect.texture = resource.texture
	item_name_label.text = resource.name
	item_description_label.text = resource.description
	for icon_info in resource.icons:
		var icon := tooltip_icon_packed_scene.instantiate() as TooltipIcon
		icon.initialize(icon_info)
		icon_container.add_child(icon)
