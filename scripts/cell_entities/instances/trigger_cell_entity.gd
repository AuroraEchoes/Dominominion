class_name TriggerCellEntity extends CellEntity

@export var fuse_length: float = 0.5
@export var trigger_radius: int = 1

var area_of_effect: AreaOfEffect
var cell_highlight_group: CellHighlighter.HighlightGroup

func _ready() -> void:
	super()
	self.area_of_effect = AreaOfEffect.new(self, trigger_radius)

func hover_started():
	var cells := area_of_effect.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.INFO)

func hover_ended():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func enter_primed():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	var cells := area_of_effect.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.WARNING)
	var fuse := Fuse.new(self, fuse_length)
	await fuse.finished
	area_of_effect.activate()
	cell_highlight_group.destroy()
	cell_highlight_group = null

