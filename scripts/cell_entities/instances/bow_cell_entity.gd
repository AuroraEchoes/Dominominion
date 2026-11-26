class_name BowCellEntity extends CellEntity

@export var offset: Vector2i
@export var charge_speed: float

@onready var offset_impl: ArbitraryOffset

func _ready():
	super()
	offset_impl = ArbitraryOffset.new(self, offset)

func get_affected_cells():
	return offset_impl.get_affected_cells()

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	highlight_affected_cells(CellHighlighter.HighlightType.WARNING)
	var charge := Charge.new(self, offset_impl.get_affected_cells(), charge_speed)
	await charge.finished
	self.offset_impl.activate()
	
	clear_cell_highlight_group()
	expire()

func enter_expired():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func exit_expired():
	offset_transform_position = Vector2.ZERO
