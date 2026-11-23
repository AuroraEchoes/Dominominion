class_name CellEntity extends TextureRect

signal cell_changed

enum State {
	DORMANT,
	PRIMED,
	ACTIVE,
	EXPIRED
}

@export var resource: ItemResource
@export var tooltip_scene: PackedScene

var cell: Vector2i
var state: State = State.DORMANT
var manager: CellEntityManager
var hovered: bool = false

func _ready() -> void:
	var level := LocalLevelManager.get_active_level()
	cell = level.spawned.local_to_map(level.spawned.to_local(global_position))
	cell_changed.emit()
	manager = level.cell_entity_manager
	manager.register(self)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	enter_dormant()

func prime():
	if state == State.DORMANT:
		exit_dormant()
		state = State.PRIMED
		enter_primed()

func activate():
	if state == State.PRIMED:
		exit_primed()
		state = State.ACTIVE
		enter_active()

func expire():
	if state == State.ACTIVE:
		exit_active()
		state = State.EXPIRED
		enter_expired()

func dormant():
	if state == State.PRIMED:
		exit_primed()
	elif state == State.ACTIVE:
		exit_active()
	elif state == State.EXPIRED:
		exit_expired()
	state = State.DORMANT
	enter_dormant()

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
	pass

func hover_ended():
	pass

func selected():
	pass

func click():
	pass

func move_to_cell(new_cell: Vector2i):
	cell = new_cell
	var level := manager.level
	global_position = level.spawned.to_global(level.spawned.map_to_local(cell) - level.spawned.tile_set.tile_size * 0.5)
	cell_changed.emit()

func destroy():
	manager.unregister(self)
	manager.level.spawned.set_cell(cell)
	queue_free()

func _get_drag_data(at_position: Vector2) -> Variant:
	if !resource.pickable:
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
		click()
