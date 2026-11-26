class_name TriggerCellEntity extends CellEntity

@export var fuse_length: float = 0.5
@export var trigger_radius: int = 1

var area_of_effect: AreaOfEffect

func _ready() -> void:
	super()
	self.area_of_effect = AreaOfEffect.new(self, trigger_radius)

func get_affected_cells() -> Array[Vector2i]:
	return area_of_effect.get_affected_cells()

func enter_primed():
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
	highlight_affected_cells(CellHighlighter.HighlightType.WARNING)
	var fuse := Fuse.new(self, fuse_length)
	await fuse.finished
	area_of_effect.activate()
	if cell_highlight_group != null:
		cell_highlight_group.destroy()
		cell_highlight_group = null
