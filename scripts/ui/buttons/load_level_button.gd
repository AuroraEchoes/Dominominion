class_name LoadLevelButton extends Button

@export var level: PackedScene
@export var level_text: String
@export var texture: Texture2D
@export var label: Label
@export var texture_rect: TextureRect

func _ready() -> void:
	label.text = level_text
	texture_rect.texture = texture

func _pressed() -> void:
	GameManager.load_level(level)
