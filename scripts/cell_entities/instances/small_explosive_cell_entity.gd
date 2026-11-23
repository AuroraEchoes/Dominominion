class_name SmallExplosiveCellEntity extends CellEntity

@export var fuse_length: float = 0.75
@export var radius: int = 2

var area_of_effect: AreaOfEffect = AreaOfEffect.new(self, radius)
var cell_highlight_group: CellHighlighter.HighlightGroup

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	var cells := area_of_effect.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.WARNING)
	var fuse := Fuse.new(self, fuse_length)
	await fuse.finished
	self.area_of_effect.activate()
	cell_highlight_group.destroy()
	cell_highlight_group = null

func hover_started():
	var cells := area_of_effect.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.INFO)

func hover_ended():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
