extends CanvasLayer

func _ready() -> void:
	print("Default Screen Orientation: ", DisplayServer.screen_get_orientation())
	
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	
	print("New Screen Orientation: ", DisplayServer.screen_get_orientation())
	
	get_window().set_content_scale_size(Vector2i(1080, 1920))
