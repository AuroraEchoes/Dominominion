class_name TargetCellEntity extends CellEntity

func _ready() -> void:
	super()
	manager.level.register_target(self)

func enter_active():
	manager.level.targets_changed.emit()

func is_eliminated():
	return state == State.ACTIVE
