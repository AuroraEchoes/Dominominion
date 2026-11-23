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

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data["source"] == "world":
		var node := data["node"] as CellEntity
		node.destroy()
		InventoryManager.add_item(data["item"])
	print("DROP!!! ", data)

func _slot_is_item(slot: InventoryItem, item: String) -> bool:
	return slot.item_path == item
