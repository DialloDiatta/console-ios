extends Control



func _ready() -> void:
	for child in %ButtonContainer.get_children():
		var level = child.level_data
		child.pressed.connect(func():
			Signals.assign_level_resource.emit(level))

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			self.queue_free()
