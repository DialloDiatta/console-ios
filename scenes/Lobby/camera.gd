extends Camera2D
# TODO Transfer over inputs from other project.godot into this one.
@export var pos_offset : Vector2
@export var zoomSpeed : float = 10
@export var targetZoomLevel : float = 1.5
var defaultZoomLevel : float = 1
var zoomTarget : Vector2 
var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging : bool = false

func _ready() -> void:
	Signals.move_camera.connect(move_to_target)
	Signals.deselect_world.connect(default_zoom)
	
	SceneManager.scene_change_started.connect(_on_scene_change_started)
	zoomTarget = zoom

func _process(delta: float) -> void:
	Zoom(delta)
	SimplePan(delta)
	ClickAndPan()

func Zoom(delta): # TODO Turn this into a nod process function.
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
	
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
	# Handles Zoom Smoothing
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	
func SimplePan(delta): # Handles W, A, S, D, Camera movement.
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("camera_move_left"):
		position.x -= 1
	
	if Input.is_action_pressed("camera_move_right"):
		position.x += 1
		
	if Input.is_action_pressed("camera_move_up"):
		position.y -= 1
		
	if Input.is_action_pressed("camera_move_down"):
		position.y += 1
	
	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1/zoom.x)
	
func ClickAndPan():
	if !isDragging and Input.is_action_just_pressed("pan_click"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	if isDragging and Input.is_action_just_released("pan_click"):
		isDragging = false
		
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x

func move_to_target(target: Node):
	var target_center = target.global_position + (target.size / 2) + pos_offset
	
	var tween = create_tween()
	tween.tween_property(self, "position", target_center, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	zoomTarget = Vector2(targetZoomLevel, targetZoomLevel)

func default_zoom():
	zoomTarget = Vector2(defaultZoomLevel, defaultZoomLevel)

func _on_scene_change_started():
	
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(2.0, 2.0), 0.9).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
