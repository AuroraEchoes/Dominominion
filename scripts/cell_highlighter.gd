class_name CellHighlighter extends Node2D

enum HighlightType {
	INFO,
	WARNING,
	POSITIVE
}

@export var parent_tilemap: TileMapLayer
@export var tile_set: TileSet
@export var tile_atlas_coords: Dictionary[HighlightType, Vector2i]

func create_highlight_group(cells: Array[Vector2i], type: HighlightType) -> HighlightGroup:
	var group := HighlightGroup.new(cells, type, tile_set, tile_atlas_coords)
	add_child(group)
	return group

func clear():
	for child in get_children():
		child.queue_free()

class HighlightGroup extends TileMapLayer:
	const PULSE_SPEED = 3.0
	const MIN_OPACITY = 0.4
	const MAX_OPACITY = 0.7

	var active_tween: Tween

	func _init(cells: Array[Vector2i], type: HighlightType, tile_set: TileSet, tile_atlas_coords: Dictionary[HighlightType, Vector2i]) -> void:
		self.tile_set = tile_set
		for cell in cells:
			set_cell(cell, 0, tile_atlas_coords[type])
		setup_tweens()
		
	func setup_tweens():
		modulate.a = 0
		var fade_in_tween := create_tween()
		fade_in_tween.tween_property(self, "modulate:a", MAX_OPACITY, PULSE_SPEED * 0.1)
		active_tween = fade_in_tween
		await fade_in_tween.finished
		var pulse_tween := create_tween().set_loops()
		pulse_tween.tween_property(self, "modulate:a", MIN_OPACITY, PULSE_SPEED * 0.5)
		pulse_tween.tween_property(self, "modulate:a", MAX_OPACITY, PULSE_SPEED * 0.5)
		active_tween = pulse_tween
		
	func destroy():
		if active_tween != null:
			active_tween.kill()
		var fade_out_tween := create_tween().tween_property(self, "modulate:a", 0.0, PULSE_SPEED * 0.1)
		await fade_out_tween.finished
		queue_free()
