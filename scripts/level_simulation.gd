extends Node
class_name LevelSimulation

signal fuse_lit(object: TimedSpawnedObject)
signal activated(object: TimedSpawnedObject)

var next_id: int = 0
var objects: Array[TimedSpawnedObject] = []
var level: Level

var eliminated_targets: Array[Vector2i]

const TRIGGER_PATH_TEMP = "res://resources/items/SpecialTrigger.tres"
const SPECIAL_PATH_TEMP = "res://resources/items/SpecialTarget.tres"

func _init(level: Level):
	self.level = level
	for cell in level.get_trigger_cells():
		var trigger = TimedSpawnedObject.new(next_id, cell, TRIGGER_PATH_TEMP)
		trigger.light_fuse()
		objects.append(trigger)
		next_id += 1
		fuse_lit.emit(trigger)

	for cell in level.targets:
		var target = TimedSpawnedObject.new(next_id, cell, SPECIAL_PATH_TEMP)
		objects.append(target)
		next_id += 1

	for item in level.get_spawned_items():
		var object = TimedSpawnedObject.new(next_id, item.cell, item.item)
		objects.append(object)
		next_id += 1

func _process(delta: float) -> void:
	for obj in objects:
		if obj.is_fuse_ticking():
			if obj.tick_fuse(delta):
				activate_object(obj)
				activated.emit(obj)

func activate_object(object: TimedSpawnedObject):
	var item_resource = ItemManager.get_item(object.item)
	if item_resource.item_effect is TargetItemEffectResource:
		level.eliminate_target(object.cell)
	else:
		var cells = item_resource.item_effect.get_affected_cells(object.cell)
		for obj in objects:
			if obj.is_unused():
				var index = cells.find(obj.cell)
				if index != -1:
					obj.light_fuse()
					fuse_lit.emit(obj)

class TimedSpawnedObject:
	var id: int
	var cell: Vector2i
	var item: String
	var fuse_lit: bool
	var fuse_time_remaining: float
	var active: bool
	var activation_time_remaining: float
	var used: bool

	func _init(id: int, cell: Vector2i, item: String) -> void:
		var item_resource = ItemManager.get_item(item)
		self.id = id
		self.cell = cell
		self.item = item
		self.fuse_lit = false
		self.active = false
		self.used = false
		self.fuse_time_remaining = item_resource.fuse_time

	func is_unused():
		return !fuse_lit && !active && !used
	
	func light_fuse():
		self.fuse_lit = true

	func is_fuse_ticking():
		return fuse_lit && !active && !used

	func tick_fuse(delta: float) -> bool:
		fuse_time_remaining -= delta
		if fuse_time_remaining <= 0.0:
			fuse_time_remaining = 0.0
			fuse_lit = false
			var repeating = ItemManager.get_item(item).repeating
			if repeating:
				active = true
			else:
				used = true
			return true
		return false

	func is_active():
		return !fuse_lit && active && !used

	func is_used():
		return !fuse_lit && !active && used
