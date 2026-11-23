class_name TargetCellEntity extends CellEntity

var all_targets: Array[Vector2i] = []
var highlight: CellHighlighter.HighlightGroup

func _ready() -> void:
	super()
	manager.level.register_target(self)
	manager.level.targets_changed.connect(_regenerate_targets)
	call_deferred("_regenerate_targets")

func _regenerate_targets():
	all_targets = []
	for cell_entity in manager.cell_entities:
		if cell_entity is TargetCellEntity:
			if !cell_entity.is_eliminated():
				all_targets.append(cell_entity.cell)

func hover_started():
	highlight = manager.level.cell_highlighter.create_highlight_group(all_targets, CellHighlighter.HighlightType.POSITIVE)

func hover_ended():
	if highlight != null:
		highlight.destroy()

func enter_active():
	manager.level.targets_changed.emit()
	modulate = Color.GREEN

func exit_active():
	modulate = Color.WHITE

func is_eliminated():
	return state == State.ACTIVE
