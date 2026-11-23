class_name LoadLevelButton extends Button

@export var level_number: int
@export var level: PackedScene

func _ready():
	text = "LEVEL " + str(level_number)

func _pressed() -> void:
	GameManager.load_level(level)
