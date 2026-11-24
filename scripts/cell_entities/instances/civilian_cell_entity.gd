class_name CivilianCellEntity extends CellEntity

var all_civilians: Array[Vector2i]
var highlight: CellHighlighter.HighlightGroup

func _ready() -> void:
	super()
	manager.level.targets_changed.connect(_regenerate_civilians)
	call_deferred("_regenerate_civilians")

func _regenerate_civilians():
	all_civilians = []
	for c in manager.cells_entities:
		if manager.cells_entities[c] is CivilianCellEntity:
			all_civilians.append(c)

func hover_started():
	highlight = manager.level.cell_highlighter.create_highlight_group(all_civilians, CellHighlighter.HighlightType.POSITIVE)

func hover_ended():
	if highlight != null:
		highlight.destroy()

func enter_active():
	manager.level.civilian_activated.emit()
