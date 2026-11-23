extends Node2D
class_name Level

signal simulation_started
signal target_eliminated

@export var terrain: TileMapLayer
@export var special: TileMapLayer
@export var spawned: TileMapLayer
@export var level_status_view: LevelStatusView

@export var special_trigger: ItemResource

var spawned_items: Array[SpawnedItemInfo] = []
var simulation: LevelSimulation

var targets: Array[Vector2i]
var triggers: Array[Vector2i]

func _ready() -> void:
	LocalLevelManager.set_active_level(self)
	for cell in special.get_used_cells():
		var data := special.get_cell_tile_data(cell)
		if data.get_custom_data("trigger") as bool:
			triggers.append(cell)
		elif data.get_custom_data("target") as bool:
			targets.append(cell)

func simulate():
	simulation = LevelSimulation.new(self)
	add_child(simulation)
	simulation_started.emit()

func get_spawned_items() -> Array[SpawnedItemInfo]:
	return spawned_items

func get_spawned_item_index_at_cell(cell: Vector2i) -> int:
	return spawned_items.find_custom(_item_info_is_at_cell.bind(cell))

func get_total_targets() -> int:
	return targets.size()

func get_targets_eliminated() -> int:
	if simulation != null:
		return simulation.eliminated_targets.size()
	else:
		return 0

func eliminate_target(cell: Vector2i):
	if simulation.eliminated_targets.find(cell) == -1:
		simulation.eliminated_targets.append(cell)
		target_eliminated.emit()

func can_drop_at_global_pos(global: Vector2) -> bool:
	var local := local_camera_pos(global)
	var tile := terrain.local_to_map(local)
	var terrain_data := terrain.get_cell_tile_data(tile)
	var placeable: bool = terrain_data.get_custom_data("placeable")
	var spawned_empty := spawned.get_cell_tile_data(tile) == null
	return placeable && spawned_empty

func drop_at_global_pos(screen_pos: Vector2, item: String):
	var local := local_camera_pos(screen_pos)
	var tile := terrain.local_to_map(local)
	var item_resource := ItemManager.get_item(item)
	spawned.set_cell(tile, item_resource.get_atlas_source_id(), Vector2i.ZERO, item_resource.get_atlas_tile_id())
	InventoryManager.drop_item(item)
	var info := SpawnedItemInfo.new(tile, item)
	spawned_items.append(info)

func local_camera_pos(global: Vector2) -> Vector2:
	return (get_viewport().get_screen_transform() * get_canvas_transform()).affine_inverse() * global

func get_trigger_cells() -> Array[Vector2i]:
	var trigger_cells: Array[Vector2i] = []
	for cell in special.get_used_cells():
		if bool(special.get_cell_tile_data(cell).get_custom_data("trigger")):
			trigger_cells.append(cell)
	return trigger_cells

func _item_info_is_at_cell(info: SpawnedItemInfo, cell: Vector2i):
	return info.cell == cell

class SpawnedItemInfo:
	var cell: Vector2i
	var item: String

	func _init(cell: Vector2i, item: String):
		self.cell = cell
		self.item = item
