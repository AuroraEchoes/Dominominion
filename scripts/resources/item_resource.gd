extends Resource
class_name ItemResource

@export var name: String
@export var texture: Texture2D
@export var pickable: bool
@export var atlas_source_id: int
@export var atlas_tile_id: int
@export_multiline var description: String
@export var icons: Array[TooltipIconInfoResource]

func get_item_name() -> String:
	return name

func get_item_texture() -> Texture2D:
	return texture

func get_atlas_source_id() -> int:
	return atlas_source_id

func get_atlas_tile_id() -> int:
	return atlas_tile_id
