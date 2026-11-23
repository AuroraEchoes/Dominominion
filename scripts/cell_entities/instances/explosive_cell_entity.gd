class_name ExplosiveCellEntity extends CellEntity

@export var fuse_length: float
@export var radius: int

@onready var area_of_effect: AreaOfEffect
var cell_highlight_group: CellHighlighter.HighlightGroup

func _ready():
	super()
	area_of_effect = AreaOfEffect.new(self, radius)

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	var cells := area_of_effect.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.WARNING)
	var fuse := Fuse.new(self, fuse_length)
	await fuse.finished
	self.area_of_effect.activate()

	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	expire()

func hover_started():
	var cells := area_of_effect.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.INFO)

func hover_ended():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func enter_expired():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	modulate.a = 0.0

func enter_dormant():
	modulate.a = 1.0
