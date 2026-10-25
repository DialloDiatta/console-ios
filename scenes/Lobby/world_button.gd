extends Control

@export var world_resource: World
var tween :Tween

@onready var emitter: CPUParticles2D = %Emitter
@onready var button: TextureButton = $WorldButton

func _ready() -> void:
	emitter.emitting = false
	Signals.deselect_world.connect(func():
		emitter.emitting = false)

func _on_world_button_pressed() -> void:
	button.pivot_offset_ratio = Vector2(0.5, 0.5)
	Signals.move_camera.emit(button)
	Signals.select_world.emit()
	
	Levels.set_world(world_resource, 0)
	print("World Set: ", world_resource)
	
	emitter.emitting = true
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_parallel(true)
	tween.tween_property(button, "scale:x", 1.2, 0.1)
	tween.tween_property(button, "scale:y", 0.75, 0.13)
	tween.tween_property(button, "rotation_degrees", randf_range(5.0, 10.0) * [-1.0, 1.0].pick_random(), 0.1)
	tween.chain().tween_property(button, "scale:x", 1.1, 0.15)
	tween.tween_property(button, "scale:y", 1.1, 0.15)
	tween.tween_property(button, "rotation_degrees", 0.0, 0.1)
