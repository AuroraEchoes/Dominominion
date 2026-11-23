extends Node

var items: Dictionary[String, ItemResource] = {}

func get_hash(item: ItemResource) -> String:
	if !items.has(item.resource_path):
		items[item.resource_path] = item
	return item.resource_path

func get_item(path: String) -> ItemResource:
	if path == "":
		return null
	if !items.has(path):
		items[path] = load(path) as ItemResource
	return items[path]
