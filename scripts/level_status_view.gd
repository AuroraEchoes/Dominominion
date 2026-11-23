extends TileMapLayer
class_name LevelStatusView

@export var atlas_id: int
@export var info_atlas_position: Vector2i
@export var warning_atlas_position: Vector2i
@export var level: Level

enum VisualisationMode {
	Info,
	FuseLit
}

var current_selected_cell = null
var nonempty_cells_to_visualisation_sources: Dictionary[Vector2i, Vector2i] = {}

func _ready() -> void:
	level.simulation_started.connect(_on_simulation_started)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		on_click(event.global_position)

func on_click(screen: Vector2):
	var local := local_camera_pos(screen)
	var cell := local_to_map(local)
	
	var item_idx := level.get_spawned_item_index_at_cell(cell)
	if current_selected_cell != null:
		hide_item_visualisation(current_selected_cell)
		current_selected_cell = null
	if item_idx != -1:
		var item = level.get_spawned_items()[item_idx]
		visualise_item(item.item, item.cell)
		current_selected_cell = cell

func visualise_item(item: String, center: Vector2i, mode: VisualisationMode = VisualisationMode.Info):
	var item_resource := ItemManager.get_item(item)
	var effect = item_resource.item_effect
	var cells = effect.get_affected_cells(center)
	var atlas_position = info_atlas_position
	match mode:
		VisualisationMode.Info:
			atlas_position = info_atlas_position
		VisualisationMode.FuseLit:
			atlas_position = warning_atlas_position
	
	for aff_cell in cells:
		set_cell(aff_cell, atlas_id, atlas_position)
		nonempty_cells_to_visualisation_sources[aff_cell] = center

func hide_item_visualisation(item: Vector2i):
	for nonempty_cell in nonempty_cells_to_visualisation_sources.keys():
		if nonempty_cells_to_visualisation_sources[nonempty_cell] == item:
			set_cell(nonempty_cell)
			nonempty_cells_to_visualisation_sources.erase(nonempty_cell)

func local_camera_pos(global: Vector2) -> Vector2:
	return (get_viewport().get_screen_transform() * get_canvas_transform()).affine_inverse() * global

func _on_simulation_started():
	level.simulation.fuse_lit.connect(_on_fuse_lit)
	level.simulation.activated.connect(_on_activated)

func _on_fuse_lit(obj: LevelSimulation.TimedSpawnedObject):
	visualise_item(obj.item, obj.cell, VisualisationMode.FuseLit)

func _on_activated(obj: LevelSimulation.TimedSpawnedObject):
	hide_item_visualisation(obj.cell)
