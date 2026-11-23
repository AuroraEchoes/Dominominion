extends Node

signal inventory_changed

var inventory: Dictionary[String, int] = {}

func _ready() -> void:
	inventory_changed.emit()

func empty_inventory():
	inventory = {}

func set_inventory(new_inventory: Dictionary[ItemResource, int]):
	empty_inventory()
	for item in new_inventory:
		var path = ItemManager.get_hash(item)
		inventory[path] = new_inventory[item]
	inventory_changed.emit()


func drop_item(item: String) -> void:
	if (inventory.has(item)):
		inventory[item] -= 1
	else:
		inventory[item] = 0
	inventory_changed.emit()

func add_item(item: String) -> void:
	if (inventory.has(item)):
		inventory[item] += 1
	else:
		inventory[item] = 1
	inventory_changed.emit()

func get_count(item: String) -> int:
	if !inventory.has(item):
		return 0
	return inventory[item]


func get_inventory() -> Dictionary[String, int]:
	return inventory
