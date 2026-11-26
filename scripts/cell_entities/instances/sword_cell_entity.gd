class_name SwordCellEntity extends CellEntity

@export var charge_speed: float
@export var max_charge_dist: int

@onready var straight_path: CastedStraightPath

func _ready():
	super()
	straight_path = CastedStraightPath.new(self, max_charge_dist)

func enter_dormant():
	offset_transform_position = Vector2.ZERO

func enter_primed():
	offset_transform_position = Vector2.ZERO

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	
	highlight_affected_cells(CellHighlighter.HighlightType.WARNING)
	var charge := Charge.new(self, straight_path.get_affected_cells(), charge_speed)
	await charge.finished
	self.straight_path.activate()

	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	
	expire()

func get_affected_cells() -> Array[Vector2i]:
	return straight_path.get_affected_cells()

func enter_expired():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

func exit_expired():
	offset_transform_position = Vector2.ZERO
