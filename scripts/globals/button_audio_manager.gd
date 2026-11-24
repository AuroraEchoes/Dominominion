extends AudioStreamPlayer

@export var button_press_sounds: Array[AudioStream]
@export var pickup_sounds: Array[AudioStream]

func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)

func _on_node_added(node: Node):
	if node is Button:
		node.pressed.connect(_on_button_pressed)

func _on_node_removed(node: Node):
	if node is Button:
		node.pressed.disconnect(_on_button_pressed)

func _on_button_pressed():
	var index := randi_range(0, button_press_sounds.size() - 1)
	play()
	var playback := get_stream_playback() as AudioStreamPlaybackPolyphonic
	if playback != null:
		playback.play_stream(button_press_sounds[index])

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		var index := randi_range(0, pickup_sounds.size() - 1)
		play()
		var playback := get_stream_playback() as AudioStreamPlaybackPolyphonic
		if playback != null:
			playback.play_stream(pickup_sounds[index])
		
	if what == NOTIFICATION_DRAG_END:
		var index := randi_range(0, button_press_sounds.size() - 1)
		play()
		var playback := get_stream_playback() as AudioStreamPlaybackPolyphonic
		if playback != null:
			playback.play_stream(button_press_sounds[index])
