class_name CellEntity extends Sprite2D

enum State {
	DORMANT,
	ACTIVE,
	EXPIRED
}

var cell: Vector2i
var state: State

func _ready() -> void:
	var level := LocalLevelManager.get_active_level()
	cell = get_meta("tile_coords") as Vector2i
	level.cell_entity_manager.register(self)

func enter_dormant():
	pass

func exit_dormant():
	pass

func enter_active():
	pass

func exit_active():
	pass

func enter_expired():
	pass

func exit_expired():
	pass
