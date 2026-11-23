class_name CivilianCellEntity extends CellEntity

var all_civilians: Array[Vector2i]
var highlight: CellHighlighter.HighlightGroup

func _ready() -> void:
	super()
	manager.level.targets_changed.connect(_regenerate_civilians)
	call_deferred("_regenerate_civilians")

func _regenerate_civilians():
	all_civilians = []
	for cell_entity in manager.cell_entities:
		if cell_entity is CivilianCellEntity:
			all_civilians.append(cell_entity.cell)

func hover_started():
	highlight = manager.level.cell_highlighter.create_highlight_group(all_civilians, CellHighlighter.HighlightType.POSITIVE)

func hover_ended():
	if highlight != null:
		highlight.destroy()

func enter_active():
	manager.level.civilian_activated.emit()
