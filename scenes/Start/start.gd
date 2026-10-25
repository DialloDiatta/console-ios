extends Control

@onready var background: TextureRect = $Background
@onready var fade: TextureRect = $Fade
@onready var logo: TextureRect = $Logo



func _ready() -> void:
	logo.hide()
	logo.show()
	background.pivot_offset_ratio = Vector2(0.5, 0.5)
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(background, "scale", Vector2(1.1, 1.1), 1.0).from(Vector2(1.2, 1.2))
	tween.tween_property(logo, "modulate:a", 1.0, 1.0).from(0.0)
	tween.tween_property(logo, "position", Vector2(624.0, 50.0), 1.0).from(Vector2(624.0, 0.0))

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			SceneManager.change_scene("res://scenes/Lobby/lobby.tscn", {"color" : Color("#fff")})
