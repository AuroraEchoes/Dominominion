class_name BowCellEntity extends CellEntity

@export var offset: Vector2i
@export var charge_speed: float

@onready var offset_impl: ArbitraryOffset
var cell_highlight_group: CellHighlighter.HighlightGroup

func _ready():
	super()
	offset_impl = ArbitraryOffset.new(self, offset)

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	var cells := offset_impl.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.WARNING)
	var charge := Charge.new(self, offset_impl.get_affected_cells(), charge_speed)
	await charge.finished
	self.offset_impl.activate()

	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	
	expire()

func hover_started():
	var cells := offset_impl.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.INFO)

func hover_ended():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func _on_direction_changed():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func enter_expired():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null


func exit_expired():
	offset_transform_position = Vector2.ZERO
