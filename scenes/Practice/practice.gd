extends Control

@export var new_console_scene: PackedScene
@onready var console_container: HBoxContainer = %ConsoleContainer
@onready var frame_select: PanelContainer = %FrameSelect
@onready var button_container: HBoxContainer = %ButtonContainer
@onready var label: Label = %Label

var console_scene = load("res://scenes/Console.tscn")

var current_value: int = 0

func _process(delta: float) -> void:
	label.text = str(current_value)

func _ready() -> void:
	Signals.base_changed.connect(set_current_value)
	Signals.group_activated.connect(set_current_value)
	Signals.group_deactivated.connect(set_current_value)
	generate_consoles(1)
	for i in button_container.get_children():
		if i is TextureButton:
			i.pressed.connect(func():
				generate_consoles(int(i.name))
				)
	

func set_current_value():
	var total: int = 0
	for i in console_container.get_children():
		if i.frame is Frame:
			total += i.frame.tally()
	current_value = total
	print(current_value)

func _on_new_console_button_pressed() -> void:
	#var instance = new_console_scene.instantiate()
	#instance.position = Vector2(960, 540)
	#add_child(instance)
	if frame_select.visible:
		frame_select.hide()
		frame_select.get_parent().hide()
	else:
		frame_select.show()
		frame_select.get_parent().show()

func generate_consoles(number_of_consoles: int):
	# Clear container.
	for child in console_container.get_children():
		child.queue_free()
	
	# Fill container.
	var consoles: Array = []
	for i in number_of_consoles:
		var instance = console_scene.instantiate()
		console_container.add_child(instance)
		consoles.append(instance.frame)
	
	# Connect Consoles
	while consoles.size() > 1:
		var current = consoles[consoles.size() - 1]
		var next = consoles[consoles.size() - 2]
		
		current.connect_next_frame(next)
		
		consoles.pop_back()


func _on_clear_button_pressed() -> void:
	Signals.clear.emit()
	set_current_value()
