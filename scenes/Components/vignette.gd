extends Control

@onready var border: Panel = $Border
@onready var gradient: ColorRect = $Gradient

func _ready() -> void:
	gradient.hide()
	border.hide()
	Signals.correct.connect(_on_correct)
	
func _on_correct():
	gradient.show()
	border.show()
	var tween = create_tween()
	tween.tween_property(gradient, "material:shader_parameter/alpha", 1.0, 0.1).from(0.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(gradient, "material:shader_parameter/alpha", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	tween.tween_callback(gradient.hide)
	
	var border_tween = create_tween()
	border_tween.tween_property(border, "modulate:a", 1.0, 0.1).from(0.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	border_tween.tween_property(border, "modulate:a", 0.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
	border_tween.tween_callback(border.hide)
