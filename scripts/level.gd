extends Node2D
class_name Level

enum LevelState {
	DORMANT,
	SIMULATING
}

signal simulation_started
signal targets_changed
signal civilian_activated
signal state_changed
signal cleared
signal pause_state_changed(new_state: bool)

@export var terrain: TileMapLayer
@export var spawned: TileMapLayer
@export var cell_highlighter: CellHighlighter
@export var starting_inventory: Dictionary[ItemResource, int]

var targets: Array[TargetCellEntity]

var cell_entity_manager: CellEntityManager = CellEntityManager.new(self)
var state: LevelState = LevelState.DORMANT
var activated_civilian: bool = false

func _ready() -> void:
	add_child(cell_entity_manager)
	LocalLevelManager.set_active_level(self)
	InventoryManager.set_inventory(starting_inventory)
	civilian_activated.connect(_on_civilian_activated)

func register_target(target: TargetCellEntity):
	targets.append(target)
	targets_changed.emit()

func reset():
	InventoryManager.set_inventory(starting_inventory)
	cell_entity_manager.clear()
	clear()

func clear():
	activated_civilian = false
	unpause()
	cell_highlighter.clear()
	cell_entity_manager.make_all_cells_dormant()
	state = LevelState.DORMANT
	state_changed.emit()
	cleared.emit()

func pause():
	get_tree().paused = true
	pause_state_changed.emit(true)

func unpause():
	if activated_civilian:
		return
	get_tree().paused = false
	pause_state_changed.emit(false)

func simulate():
	simulation_started.emit()
	state = LevelState.SIMULATING
	state_changed.emit()

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
	return !is_cell_occupied(tile)

func is_cell_occupied(cell: Vector2i):
	var terrain_data := terrain.get_cell_tile_data(cell)
	var placeable := false
	if terrain_data != null:
		placeable = terrain_data.get_custom_data("placeable")
	var is_filled := cell_entity_manager.is_cell_filled(cell)
	return !placeable || is_filled

func drop_at_global_pos(screen_pos: Vector2, data):
	var item: String = data["item"]
	var local := local_camera_pos(screen_pos)
	var tile := terrain.local_to_map(local)
	var item_resource := ItemManager.get_item(item)
	if data["source"] == "world":
		print("move from world")
		var node: CellEntity = data["node"]
		node.move_to_cell(tile)
	elif data["source"] == "inventory":
		print("move from inventory")
		spawned.set_cell(tile, item_resource.get_atlas_source_id(), Vector2i.ZERO, item_resource.get_atlas_tile_id())
		InventoryManager.drop_item(item)

func local_camera_pos(global: Vector2) -> Vector2:
	return (get_canvas_transform()).affine_inverse() * global

func _on_civilian_activated():
	pause()
	activated_civilian = true
