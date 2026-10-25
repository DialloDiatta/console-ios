extends TextureButton

@export var level_data: Level

@onready var label: Label = $CenterContainer/Label

var hover_scale: Vector2 = Vector2(1.1, 1.1)

func _ready() -> void:
	label.text = level_data.level_name

func _on_pressed() -> void:
	if level_data.scene_path:
		get_tree().change_scene_to_file(level_data.scene_path)
		Levels.current_level_resource = (level_data)
	else:
		push_error("No Level Data Scene Path Set")
		return

func _on_mouse_entered() -> void:
	pivot_offset = size / 2
	create_tween().tween_property(self, "scale", hover_scale, 0.1).set_trans(Tween.TRANS_SINE)


func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_SINE)
