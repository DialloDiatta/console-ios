extends TextureButton

@export_file("*.tscn") var next_scene

#func _ready() -> void:
	#self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if next_scene:
		SceneManager.change_scene(next_scene)
	else:
		push_error("No Scene Path Assigned")
