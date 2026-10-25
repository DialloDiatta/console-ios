extends Control

@onready var flame: ColorRect = $ColorRect

var on_fire: bool = false

func _ready() -> void:
	Signals.start_streak.connect(start_fire)
	Signals.end_streak.connect(stop_fire)
	
	stop_fire()
	#start_fire()
	#for i in 3:
		#transition_fire(i)
		#await get_tree().create_timer(3).timeout
	#stop_fire()

func start_fire():
	if !on_fire:
		on_fire = true
		var tween = create_tween()
		tween.set_parallel()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(flame.material, "shader_parameter/Step", 1.0, 0.5).from(0.0)

func transition_fire(level: int):
	var speed : Vector2 = Vector2(0,0)
	var tween = create_tween()
	tween.set_parallel()
	
	match level:
		0:
			speed = Vector2(0.0, 0.25)
		1:
			speed = Vector2(0.0, 0.5)
		2: 
			speed = Vector2(0.0, 0.75)

	tween.tween_property(flame.material, "shader_parameter/Speed", speed, 1.0)

func stop_fire():
	on_fire = false
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(flame.material, "shader_parameter/Step", 0.0, 0.5)
