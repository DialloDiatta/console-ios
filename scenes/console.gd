extends Control

@onready var frame: Frame = %Frame
@onready var button_container: Control = %ButtonContainer
@onready var line: ColorRect = %Line

#var is_dragging: bool = false
#var initialPos = Vector2.ZERO
#

func _ready() -> void:
	for child in button_container.get_children():
		if child is TextureButton:
			child.pressed.connect(func():
				frame.change_base(int(child.name))
				if child.active_position:
					line.position = child.active_position
				else:
					push_error("No Active Position set. Update T-Button Node.")
				Signals.base_changed.emit()
				)
				
				

func _input(event: InputEvent) -> void:
	var current_value = 0
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pass
			elif !event.pressed:
				if frame:
					current_value += frame.tally()
					print("Current Value: ", current_value)

#func _process(delta: float) -> void:
	#if is_dragging:
		#self.global_position = get_global_mouse_position() - initialPos
#
#func _on_connector_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#is_dragging = true
			#initialPos = self.get_local_mouse_position()
		#else:
			#is_dragging = false
