extends Sprite2D

@export var rest_texture: Texture2D
@export var grab_texture: Texture2D
@export var write_texture: Texture2D

var neutral: Texture2D
var click: Texture2D

func _ready() -> void:
	texture = rest_texture
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#StatesManager.state_changed.connect(set_textures)
	#set_textures(StatesManager.state)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + offset
	#if StatesManager.state == StatesManager.States.MOVE:
	if Input.is_action_pressed("click"):
		texture = grab_texture
	else:
		texture = rest_texture
	# TODO This code was intended to switch texture when in draw mode.
	#if StatesManager.state == StatesManager.States.DRAW:
		#texture = write_texture

#func set_textures(current_state):
	#if current_state == StatesManager.States.MOVE:
		#neutral = rest_texture
		#click = grab_texture
		#change_offset(Vector2(-5, 0))
	#if current_state == StatesManager.States.DRAW:
		#neutral = write_texture
		#click = write_texture
		#change_offset(Vector2(35, 4))

func change_offset(new_pos: Vector2):
	offset = new_pos
	
