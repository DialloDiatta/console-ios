extends GridContainer
class_name Frame

signal active_toggled

# The next frame might be the child of another node. Change reference accordingly.
@export var next_frame : Frame
@export var frame_threshold : int = 15
@export var modifier: int = 1

var active_cells = [] # Active = cell having sex. Cell can be active but not end full.

var next_group: String = ""

var active_frame: bool = false

@onready var cells: Array # All children cells.
@onready var group_button: TextureButton = $GroupButton

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var activate_sfx = "res://assets/sfx/arnav_geddada-ui-sound-374228.mp3"
var deactivate_sfx = ""

# TODO Change the name of these var's to something more intuitive.
var is_dragging # Tracks to see if the mouse is clicked and dragging.
var has_dragged: bool = false

##region Testing
#@onready var label: Label = $Label
#
#func _process(delta: float) -> void:
	#label.text = "Is Dragging: " + str(is_dragging) + "\n Active Cells: " + str(active_cells)
##endregion

func _ready() -> void:
	Signals.clear.connect(deactivate_all_cells)
	
	# Connect to child grid cell signals
	for i in self.get_children():
		if i is Cell:
			cells.append(i)
			i.gui_input.connect(_on_cell_gui_input.bind(i))
			i.mouse_entered.connect(_on_cell_mouse_entered.bind(i))
			i.mouse_exited.connect(_on_cell_mouse_exited.bind(i))
			
	print(cells)
	
#region Direction
"""
The new system:
	Instead of instantiating bead scenes whenever a new bead it place, instead we will
	pass the bead data from one place to another. 
	
	When you drag a "bead" onto a grid cell, it will pass that information to the grid 
	cell which will then turn on it's texture and transfer the value of that bead. 
	
	If you want to place a bead in empty space, the interface will check to see it's 
	hovered over a grid. If not, it will then and only then send a signal with the 
	position and the actual bead scene and place it in the playspace. 
	What was seen before would just be a preview. 
	
Frame:
	Handles tallying the values of all it's children. 
	Handles instructing it's children.
		When to group, when to clear, when to change, etc, but not how to clear.
	Receives signals from it's children when they change and handle those changes.
	Communicates with other grid frames.
	Tracks the coordinates of each grid cell.
	Sets the groups of pieces / cells.
	Handles scene wide Inputs (clear / reset)
	Tells what cells to activate when one of them are pressed.
	Tells each cell on start what it's coordinate is so it can store it for later.
	Signals front end visuals.
	Tracks an array of active cells. (Active =/= full)

Grid Cell:
	Signals any changes to the cell to it's parent
	Handles front end visuals. (Including animations, shaders, etc.)
	Handles variables used for tallying. i.e. full (bool), value (int), etc.
	Holds all logic that frame parent will signal later. 
	Handles localized inputs. (right click to clear)
	
Group Cell:
	Signals the interface to group.
	
SFX:
	Sound is triggered by signals emitted from the frame parent of grid cells.

"""
#endregion

func _unhandled_input(event: InputEvent) -> void:
	# TODO Might need to make these group names dynamic in the future.
	# Handles Key Presses to activate cells.
	if event.is_action_pressed("num_4"):
		key_press_activate("1")
	if event.is_action_pressed("num_5"):
		key_press_activate("2")
	if event.is_action_pressed("num_6"):
		key_press_activate("4")
	if event.is_action_pressed("num_plus"):
		key_press_activate("8")
		

### Frame will need to connect each of it's childrens signals to these scripts.
func _on_cell_gui_input(event: InputEvent, cell: Cell):
	# This motion code "works" but it's a little touch and go with sensitive devices.
	# Could add a drag threshold. Prolly will TODO that later. Check Claude 5/10/26
	if event is InputEventMouseMotion and is_dragging:
		has_dragged = true
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: # Left Click Logic
			if event.pressed:
				if cell.full:
					is_dragging = true
					active_cells.append(cell)
				else:
					activate_group(cell.get_groups()[0])
			else: # or if left click released because LMB only has 1 signal.
				if has_dragged and active_cells:
					clear_carry(active_cells[0])
					if !next_group:
						deactivate_group(cell.get_groups()[0])
				elif !has_dragged and active_cells:
					deactivate_group(cell.get_groups()[0])
				is_dragging = false
				has_dragged = false
				active_cells.clear()
				
		if event.button_index == MOUSE_BUTTON_RIGHT: # Right Click Logic
			deactivate_group(cell.get_groups()[0])

func _on_cell_mouse_entered(cell: Cell):
	
	if !cell.full and is_dragging:
		var cell_group = cell.get_groups()[0]
		for c in cells:
			if c.is_in_group(cell_group):
				c.activate_overlay() # turns overlay on when entered.
		next_group = cell_group
	
func _on_cell_mouse_exited(cell: Cell):
	# Right now, this deactivates the overlays in all var cell_group across all frames.
	# TODO We can tighten this up later but it's not hurting anything rn.
	var cell_group = cell.get_groups()[0]
	get_tree().call_group(cell_group, "deactivate_overlay")
	next_group = ""
	
#func _on_cell_theme_changed(cell: Cell):
	#pass
###

func _on_group_button_pressed() -> void:
	# Important we multiply by modifer, else the second column will think we need to 
	# group at 16 over 160. (column 1 = base16+1 column 2 = base16*10)
	# column should be = frame_threshold or base * modifiers or the value of each cell.
	if tally() >= frame_threshold * modifier: 
		group_next_frame()
	else:
		group()
		print("Not ready")

func group(): # TODO Have Claude explain how this works.
	# deactivates all current cells and sends a signal to activate the first cell of
	# the next frame.
	var groups = ["1", "2", "4", "8"]
	
	for i in groups.size():
		var group_name = groups[i]
		var group_cells = cells.filter(func(c): return c.is_in_group(group_name))
		var is_full = group_cells.all(func(c): return c.full)
		
		if not is_full:
			# Fill this group
			for cell in group_cells:
				cell.activate()
			# Clear all smaller groups that carried into this one
			for j in i:
				var carry_cells = cells.filter(func(c): return c.is_in_group(groups[j]))
				for cell in carry_cells:
					cell.deactivate()
			Signals.group_activated.emit()
			return
	group_next_frame()
	print("Overflow! All groups full.") # Handle however fits your game

func group_next_frame():
	if next_frame:
		next_frame.group()
		deactivate_all_cells()
	else:
		push_error("No Frame Connected to: ", self.name)

func activate_group(cell_group: String): 
	# Takes the cells in a group and activates them.
	for cell in cells:
		if cell.is_in_group(cell_group):
			cell.activate()
			cell.deactivate_overlay() # Turns overlay off when activated.
	Signals.group_activated.emit()
	_play_sound(activate_sfx)
# TODO I should be able to combine these scripts into toggle_group(state: bool, cell_group)
# TODO I might also be able to just add this in the grid_cell script.
func deactivate_group(cell_group: String):
	# Reverse of activate_group()
	for cell in cells:
		if cell.is_in_group(cell_group):
			cell.deactivate()
	Signals.group_deactivated.emit()
	_play_sound(deactivate_sfx)
	

func activate_all_cells():
	for cell in cells:
		cell.activate()
	_play_sound(activate_sfx)

func deactivate_all_cells():
	for cell in cells:
		cell.deactivate()
	_play_sound(deactivate_sfx)

func key_press_activate(cell_group: String):
	if active_frame:
		var group_cells: Array = cells.filter((func(c): return c.is_in_group(cell_group)))
		if group_cells.is_empty():
			return
		if group_cells[0].full:
			deactivate_group(cell_group)
		else:
			activate_group(cell_group)

func get_next_group():
# Should return the next group. Will be run whenever a mouse entered signal is triggered.
	return next_group 

func clear_carry(current_cell: Cell):
	# This will run when the press is released.
	print("Clear Carry:")
	if next_group:
		deactivate_group(current_cell.get_groups()[0])
		activate_group(next_group)

func tally() -> int:
	# Finds the total value of the playspace using filled grid cells.
	# We can add a multiplier here later for different BITRIC systems.
	var full_cells: int = 0
	
	for cell in cells:
		if cell.full:
			full_cells += 1
	
	full_cells *= modifier
	
	return full_cells

func change_base(new_frame_threshold: int):
	if new_frame_threshold is int:
		frame_threshold = new_frame_threshold
		print("Base Changed: ", frame_threshold)
	else:
		push_error("Not a valid value. Looking for 'int'. Change Button Name")
	
	if next_frame: # TODO
		next_frame.modifier = frame_threshold

func connect_next_frame(next: Frame): # runs once when instantiated in other scene.
	next_frame = next
	next.modifier = frame_threshold
	print("Next Frame Connected to ", self.name)

func _play_sound(sfx_path: String):
	var sfx = load(sfx_path) 
	# TODO Setup sounds so only one plays instead of several trying to play at once.
	
	audio_stream_player.stream = sfx
	
	audio_stream_player.play() # 0.29 is the sound offset.
