extends Node

signal inventory_changed

var inventory: Dictionary[String, int] = {}

func _ready() -> void:
	inventory["res://resources/items/SmallExplosive.tres"] = 2
	inventory_changed.emit()

func drop_item(item: String):
	if (inventory.has(item)):
		inventory[item] -= 1
	else:
		inventory[item] = 0
	inventory_changed.emit()

func add_item(item: String):
	if (inventory.has(item)):
		inventory[item] += 1
	else:
		inventory[item] = 1
	inventory_changed.emit()


func get_inventory() -> Dictionary[String, int]:
	return inventory
