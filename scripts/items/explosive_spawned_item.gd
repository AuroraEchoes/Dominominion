extends SpawnedItem
class_name ExplosiveSpawnedItem

func _ready() -> void:
	var shake := ItemShake.new(self, 0.75, 1, 0.5)

# for graphics
func use():
	
	pass
