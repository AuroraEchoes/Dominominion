class_name SwordCellEntity extends CellEntity

@export var charge_speed: float
@export var max_charge_dist: int

@onready var straight_path: CastedStraightPath
var cell_highlight_group: CellHighlighter.HighlightGroup

func _ready():
	super()
	straight_path = CastedStraightPath.new(self, max_charge_dist)

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	var cells := straight_path.get_affected_cells()
	cell_highlight_group = manager.level.cell_highlighter.create_highlight_group(cells, CellHighlighter.HighlightType.WARNING)
	var charge := Charge.new(self, straight_path.get_affected_cells(), charge_speed)
	await charge.finished
	self.straight_path.activate()

	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	
	expire()

func hover_started():
	var cells := straight_path.get_affected_cells()
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
