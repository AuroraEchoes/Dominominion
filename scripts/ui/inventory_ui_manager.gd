extends Control

@export var container: Container
@export var inventory_slot_scene: PackedScene

var inventory_items: Array[InventoryItem] = []

func _ready() -> void:
	InventoryManager.inventory_changed.connect(_on_inventory_changed)
	_on_inventory_changed()

func _on_inventory_changed():
	var inventory := InventoryManager.get_inventory()
	for item in inventory.keys():
		var count := inventory[item]
		var current_idx := inventory_items.find_custom(_slot_is_item.bind(item))
		if current_idx == -1:
			var new_slot = inventory_slot_scene.instantiate() as InventoryItem
			container.add_child(new_slot)
			new_slot.init(item, count)
			inventory_items.append(new_slot)
		elif count <= 0:
			var current := inventory_items[current_idx]
			inventory_items.remove_at(current_idx)
			current.queue_free()
		else:
			var current := inventory_items[current_idx]
			current.set_count(count)


func _slot_is_item(slot: InventoryItem, item: String) -> bool:
	return slot.item_resource == item
