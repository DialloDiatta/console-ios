extends Control

func _ready() -> void:
	get_window().set_content_scale_size(Vector2i(1920, 1080))

func _on_gui_input(event: InputEvent) -> void:
	pass

func _on_bg_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Signals.deselect_world.emit()
		print("clicked")
