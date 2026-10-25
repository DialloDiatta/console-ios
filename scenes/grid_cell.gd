extends PanelContainer
class_name Cell

@export var full = false
@export var value: int = 1
@export var next_group: String
@onready var texture: TextureRect = $Texture
@onready var overlay: ColorRect = %Overlay


func _ready() -> void:
	deactivate()
	deactivate_overlay()


func change_color(color:Color):
	var styleBox := get_theme_stylebox("panel").duplicate()
	styleBox.bg_color = color
	add_theme_stylebox_override("panel",styleBox)

func activate():
	AudioManager.activate_cell.emit()
	texture.show()
	full = true
	
func deactivate():
	AudioManager.deactivate_cell.emit()
	texture.hide()
	full = false

func activate_overlay():
	overlay.show()

func deactivate_overlay():
	overlay.hide()

func _on_gui_input():
	# Click
	
	# Click Released
	
	# Clear
	pass
