# TODO Organize script (functions).
extends Control

@export var game_data: Level

@onready var timer: Timer = %Timer
@onready var streak_timer: Timer = %StreakTimer
@onready var progress_bar = %ProgressBar
@onready var label: Label = %Label
@onready var play_button: Button = %PlayButton
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

@export var pop_up_scene: PackedScene # TODO Get rid of this or repurpose.

# Going to need to use the find_frames() in the future to handle multiple of these.
# @onready var frame_2: Frame = $Control2/Frame2
var frames: Array = []
var current_frame_index: int = 0

var last_number: int = -1
var puzzles_completed: int:
	set(value):
		puzzles_completed = value
		if puzzles_completed == game_data.goal:
			end_level(true)
		
var streak: int:
	set(value):
		streak = value
		if streak >= streak_threshold:
			Signals.start_streak.emit() # TODO Kinda a misnomer cause a streak starts as soon as a puzzle is completed... For now.
			print("Streak!: ", streak)
var longest_streak: int:
	set(value):
		longest_streak = value
		print("New Streak!: ", longest_streak)
var streak_threshold: int = 4
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
	#Signals.assign_level_resource.connect(func(level: Level):
		#game_data = level
		#print("Game Data Set: ", level.level_id)
		#reset_interface()
		#)
	
	## Level Data Port
	game_data = Levels.current_level_resource
	
	
	## Frame Logic
	frames = find_frames()
	if frames:
		frames[current_frame_index].active_frame = true
	
	reset_interface()

func _process(_delta: float) -> void:
	if timer.time_left > 0:
		progress_bar.value = (timer.time_left / timer.wait_time) * 100.0
	else:
		progress_bar.value = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_frame"):
		cycle_frames(1)
	if event.is_action_pressed("prev_frame"):
		cycle_frames(-1)
	if event.is_action_pressed("clear"):
		for i in frames:
			i.deactivate_all_cells()
	if event.is_action_pressed("start"):
		start_level()

func _on_play_button_pressed():
	if game_data:
		start_level()
		print("Current Level: ", Levels.current_level_resource.level_name)
	else:
		var instance = pop_up_scene.instantiate()
		add_child(instance)
	
func _on_timer_timeout():
	# Open window to show score.
	print("Timer Stopped")
	print("Puzzles Completed: ", puzzles_completed)
	end_level(false)

func _on_streak_timer_timeout() -> void:
	if streak > longest_streak:
		longest_streak = streak
	streak = 0
	Signals.end_streak.emit()

func check():
	# Checks to see if the playspace value is the same as the goal.
	if current_value == goal:
		Signals.correct.emit()
		audio_stream_player.play()
		puzzles_completed += 1
		timer.set_paused(true)
		streak_timer.set_paused(true)
		if timer.time_left and streak_timer.time_left : # 2 is the streak modifier.
			streak += 1
		
		return true
	else:
		return false

func set_current_value():
	var total: int = 0
	for i in frames:
		total += i.tally()
	current_value = total
	print(current_value)

func next_puzzle():
	for i in frames:
		i.deactivate_all_cells()
	set_goal()
	
func reset_interface():
	label.text = "Ready"
	puzzles_completed = 0

func apply_multipliers():
	# Applies the bitric column value. ie 1 * 16 or full_cells * bitric column
	pass # TODO Don't think we need this anymore.

func start_level():
	print("Game Start")
	timer.wait_time = game_data.wait_time
	streak_timer.wait_time = game_data.wait_time * 0.75
	set_goal()

func set_goal():
	var new_goal = random()
	goal = new_goal
	label.text = str(new_goal)
	
	timer.start()
	timer.set_paused(false)
	streak_timer.start()
	streak_timer.set_paused(false)
	

func end_level(reach_goal: bool):
	Signals.end_level.emit(puzzles_completed, reach_goal)
	print("Congratulations!! You completed the level!")

func random():
	# TODO Replace static values with level resource references.
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_number = rng.randi_range(game_data.lowest, game_data.highest)
	
	while new_number == last_number:
		new_number = rng.randi_range(game_data.lowest, game_data.highest)
		print("Duplicate Dectected: ", last_number)
	
	last_number = new_number
	return new_number

func find_frames() -> Array:
	return find_children("*", "Frame")

func cycle_frames(direction: int):
	if frames.is_empty():
		return
	frames[current_frame_index].active_frame = false # TODO Pick up here 6-26-2026 7:39 PM EST
	current_frame_index = wrapi(current_frame_index + direction, 0, frames.size())
	frames[current_frame_index].active_frame = true
	
func _on_select_game_button_pressed() -> void: # TODO Delete
	if pop_up_scene:
		var instance = pop_up_scene.instantiate()
		add_child(instance)
	else:
		push_error("No Pop Up Scene Assigned.")
