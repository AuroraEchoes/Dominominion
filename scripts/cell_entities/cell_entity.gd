class_name CellEntity extends TextureRect

signal cell_changed
signal direction_changed

signal entered_dormant
signal exited_dormant
signal entered_primed
signal exited_primed
signal entered_active
signal exited_active
signal entered_expired
signal exited_expired

enum State {
	DORMANT,
	PRIMED,
	ACTIVE,
	EXPIRED
}

@export var resource: ItemResource
@export var tooltip_scene: PackedScene
@export var base_rotation: float
@export var base_direction: Vector2i = Vector2i.UP

var cell: Vector2i
var state: State = State.DORMANT
var manager: CellEntityManager
var hovered: bool = false
var direction: Vector2i
var cell_highlight_group: CellHighlighter.HighlightGroup

func _ready() -> void:
	var level = LocalLevelManager.get_active_level()
	cell = level.spawned.local_to_map(level.spawned.to_local(global_position))
	cell_changed.emit()
	manager = level.cell_entity_manager
	manager.register(self)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	offset_transform_enabled = true
	direction = base_direction
	var angle = -Vector2(direction).angle_to(Vector2.UP) + deg_to_rad(base_rotation)
	offset_transform_rotation = angle
	direction_changed.emit()

	enter_dormant()
	entered_dormant.emit()

func prime():
	if state == State.DORMANT:
		exit_dormant()
		exited_dormant.emit()
		state = State.PRIMED
		enter_primed()
		entered_primed.emit()

func activate():
	if state == State.PRIMED:
		exit_primed()
		exited_primed.emit()
		state = State.ACTIVE
		enter_active()
		entered_active.emit()

func expire():
	if state == State.ACTIVE:
		exit_active()
		exited_active.emit()
		state = State.EXPIRED
		enter_expired()
		entered_expired.emit()

func dormant():
	if state == State.PRIMED:
		exit_primed()
		exited_primed.emit()
	elif state == State.ACTIVE:
		exit_active()
		exited_active.emit()
	elif state == State.EXPIRED:
		exit_expired()
		exited_expired.emit()
	state = State.DORMANT
	enter_dormant()
	entered_dormant.emit()

func get_affected_cells() -> Array[Vector2i]:
	return []

func clear_cell_highlight_group() -> void:
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func highlight_affected_cells(type: CellHighlighter.HighlightType) -> void:
	var cells := get_affected_cells()
	clear_cell_highlight_group()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.INFO)

func enter_dormant():
	pass

func exit_dormant():
	pass

func enter_primed():
	pass

func exit_primed():
	pass

func enter_active():
	pass

func exit_active():
	pass

func enter_expired():
	pass

func exit_expired():
	pass

func hover_started():
	highlight_affected_cells(CellHighlighter.HighlightType.INFO)

func hover_ended():
	clear_cell_highlight_group()

func selected():
	pass

func click():
	pass

func move_to_cell(new_cell: Vector2i):
	var old_cell := cell
	cell = new_cell
	var level := manager.level
	global_position = level.spawned.to_global(level.spawned.map_to_local(cell) - level.spawned.tile_set.tile_size * 0.5)
	manager.change_cell(old_cell, new_cell)
	cell_changed.emit()

func destroy():
	manager.unregister(self)
	queue_free()

func rotate_direction():
	if direction == Vector2i.RIGHT:
		direction = Vector2i.DOWN
	elif direction == Vector2i.DOWN:
		direction = Vector2i.LEFT
	elif direction == Vector2i.LEFT:
		direction = Vector2i.UP
	elif direction == Vector2i.UP:
		direction = Vector2i.RIGHT
	else:
		direction = Vector2i.UP
	var angle = -Vector2(direction).angle_to(Vector2.UP) + deg_to_rad(base_rotation)
	offset_transform_rotation = angle
	direction_changed.emit()
	if hovered:
		highlight_affected_cells(CellHighlighter.HighlightType.INFO)


func _get_drag_data(at_position: Vector2) -> Variant:
	if !resource.pickable || manager.level.state != Level.LevelState.DORMANT:
		return null
	set_drag_preview(_get_drag_preview())
	modulate.a = 0.4
	return { "item": ItemManager.get_hash(resource), "source": "world", "cell": cell, "node": self }

func _get_drag_preview() -> Control:
	var preview := IconDragPreview.new()
	preview.init(get_canvas_transform(), resource.get_item_texture())
	return preview

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0

func _on_mouse_entered():
	hovered = true
	hover_started()
	pass

func _on_mouse_exited():
	hovered = false
	hover_ended()

func _get_tooltip(at_position: Vector2) -> String:
	return ItemManager.get_hash(resource)

func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip := tooltip_scene.instantiate() as Tooltip
	tooltip.initialize(resource)
	return tooltip

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && hovered:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT && mouse_event.pressed:
			rotate_direction()
		else:
			click()
