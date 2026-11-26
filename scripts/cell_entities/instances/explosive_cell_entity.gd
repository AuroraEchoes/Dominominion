class_name ExplosiveCellEntity extends CellEntity

@export var fuse_length: float
@export var radius: int

@onready var area_of_effect: AreaOfEffect

func _ready():
	super()
	area_of_effect = AreaOfEffect.new(self, radius)

func enter_active():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	highlight_affected_cells(CellHighlighter.HighlightType.WARNING)
	var fuse := Fuse.new(self, fuse_length)
	await fuse.finished
	self.area_of_effect.activate()

	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null

	expire()

func get_affected_cells() -> Array[Vector2i]:
	return area_of_effect.get_affected_cells()

func enter_expired():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	modulate.a = 0.2

func enter_dormant():
	modulate.a = 1.0
