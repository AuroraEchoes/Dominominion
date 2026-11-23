class_name SmallExplosiveCellEntity extends CellEntity

@export var fuse_length: float = 0.75

func enter_active():
	await Fuse.new(self, fuse_length)
	print("exploding")
