extends Node2D
class_name Level

signal simulation_started
signal targets_changed

@export var terrain: TileMapLayer
@export var spawned: TileMapLayer
@export var cell_highlighter: CellHighlighter

var targets: Array[TargetCellEntity]

var cell_entity_manager: CellEntityManager = CellEntityManager.new(self)

func _ready() -> void:
	add_child(cell_entity_manager)
	LocalLevelManager.set_active_level(self)

func register_target(target: TargetCellEntity):
	targets.append(target)
	targets_changed.emit()

func simulate():
	simulation_started.emit()

func get_total_targets() -> int:
	return targets.size()

func get_targets_eliminated() -> int:
	var count := 0
	for target in targets:
		if target.is_eliminated():
			count += 1
	return count

func can_drop_at_global_pos(global: Vector2) -> bool:
	var local := local_camera_pos(global)
	var tile := terrain.local_to_map(local)
	var terrain_data := terrain.get_cell_tile_data(tile)
	var placeable: bool = terrain_data.get_custom_data("placeable")
	var spawned_empty := spawned.get_cell_tile_data(tile) == null
	return placeable && spawned_empty

func drop_at_global_pos(screen_pos: Vector2, data):
	var item: String = data["item"]
	var local := local_camera_pos(screen_pos)
	var tile := terrain.local_to_map(local)
	var item_resource := ItemManager.get_item(item)
	if data["source"] == "world":
		var node: CellEntity = data["node"]
		node.move_to_cell(tile)
	else:
		spawned.set_cell(tile, item_resource.get_atlas_source_id(), Vector2i.ZERO, item_resource.get_atlas_tile_id())
		InventoryManager.drop_item(item)

func local_camera_pos(global: Vector2) -> Vector2:
	return (get_canvas_transform()).affine_inverse() * global
