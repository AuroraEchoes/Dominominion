class_name TooltipIcon extends Control

@export var panel: PanelContainer
@export var texture_rect: TextureRect
@export var label: Label

func initialize(info: TooltipIconInfoResource):
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = info.color
	stylebox.set_corner_radius_all(8)
	# panel.add_theme_font_override("panel", stylebox)
	texture_rect.texture = info.icon
	label.text = info.text
