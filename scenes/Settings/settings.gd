extends Control

var panels: Array[Node] = []
@onready var button_container: VBoxContainer = %ButtonContainer
@onready var panel_parent: Node = %PanelParent


func _ready() -> void:
	panels = panel_parent.get_children()
	var buttons = button_container.get_children()
	
	for button in buttons:
		var button_index = buttons.find(button)
		button.pressed.connect(show_panel.bind(panels[button_index]))
		print("Button Index: ", str(button_index))
	
	# TODO Handle 
	show_panel(panels[0])

func show_panel(panel_to_show: PanelContainer) -> void:
	for panel in panels:
		panel.hide()
		
	panel_to_show.show()
