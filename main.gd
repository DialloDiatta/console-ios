# TODO Organize script (functions).
extends Control

var game_data: Level = null

@onready var timer: Timer = %Timer
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label: Label = %Label
@onready var play_button: Button = %PlayButton
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var pop_up_scene: PackedScene

# Going to need to use the find_frames() in the future to handle multiple of these.
@onready var frame_2: Frame = $Control2/Frame2

var puzzles_completed: int = 0
var goal: int = 9999 # Set this high so the game doesn't mistakenly start.
var current_value: int: # TODO could add a set function that checks goal anytime this changes?
	set(value):
		current_value = value
		if check():
			await get_tree().create_timer(0.5).timeout
			next_puzzle()
		else:
			pass

func _ready() -> void:
	Signals.group_activated.connect(set_current_value)
	Signals.group_deactivated.connect(set_current_value)
	Signals.assign_level_resource.connect(func(level: Level):
		game_data = level
		print("Game Data Set: ", level.level_id)
		reset_interface()
		)
	game_data = Levels.get_game_data()
	reset_interface()

func _process(_delta: float) -> void:
	progress_bar.value = timer.time_left
	progress_bar.max_value = timer.wait_time

func _on_play_button_pressed():
	if game_data:
		start()
	else:
		var instance = pop_up_scene.instantiate()
		add_child(instance)
	
func _on_timer_timeout():
	# Open window to show score.
	print("Timer Stopped")
	print("Puzzles Completed: ", puzzles_completed)
	pass

func check():
	# Checks to see if the playspace value is the same as the goal.
	if current_value == goal:
		audio_stream_player.play()
		puzzles_completed += 1
		return true
	else:
		return false

func set_current_value():
	current_value = frame_2.tally()
	print(frame_2.tally())

func next_puzzle():
	for cell in frame_2.cells:
		cell.deactivate()
	set_goal()

func reset_interface():
	label.text = "Ready"
	play_button.text = "Play"
	puzzles_completed = 0

func apply_multipliers():
	# Applies the bitric column value. ie 1 * 16 or full_cells * bitric column
	pass

func start():
	print("Game Start")
	
	set_goal()

func set_goal():
	var new_goal = random()
	goal = new_goal
	label.text = str(new_goal)
	
	timer.start()
	
func random():
	# TODO Replace static values with level resource references.
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_number = rng.randi_range(game_data.lowest, game_data.highest)
	var last_number: int = -1
	
	while new_number == last_number:
		new_number = rng.randi_range(game_data.lowest, game_data.highest)
		print("Duplicate Dectected: ", last_number)
	
	last_number = new_number
	return new_number

func find_frames():
	var frames: Array = []
	
	return frames


func _on_select_game_button_pressed() -> void:
	if pop_up_scene:
		var instance = pop_up_scene.instantiate()
		add_child(instance)
	else:
		push_error("No Pop Up Scene Assigned.")
