extends Node

var current_world_resource: World:
		set(value):
			current_world_resource = value
			if current_world_resource:
				print("World Resource Set: ", current_world_resource.name)
			else:
				push_error("No World Resource Set. Assign 'World' to WorldButton")
var current_level_resource: Level

func _ready() -> void:
	Signals.select_world.connect(func(world):	
		current_world_resource = world
		)
	#Signals.assign_level_resource.connect(func(level):
		#current_level_resource = level
		#)

#func get_game_data():
	## TODO Right level data and references are passed directly from the button to scene.
	#if current_world_resource:
		#current_level_resource = current_world_resource.levels[0]
	#if current_level_resource:
		#print("World Resource Set: ", current_level_resource.level_name)
		#return current_level_resource
	#else:
		## TODO temp code
		#print("No Level Resource Set: Switching to Default")
		#var temp_level = Level.new()
		#temp_level.lowest = 1
		#temp_level.highest = 15
		#temp_level.level_name = "Temp Level"
		#return temp_level
		

func set_game_data(level: Level):
	current_level_resource = level

#region New Code Region
"""
World resource shouldn't be necessary. A LevelManager level resource should be enough. World
resources can be for ui and data management.,

Level resource will hold relevant level data. Highest, Lowest, time limit etc.

Because levels progress by just using the same scene and changing the relevant Level resource,
logic for going to the next resource can live inside the level manager. We'd just progress to 
the next resource in the current world. So we will need to use a world resource, but it will
only be used for organizing the levels.

Select World -> Select Level -> Complete Level -> Select Next Level -> Load new level resource,
Restart current scene, make adjustments based on level data -> Play Next Level

Freedom Units will use a hidden progression system. Players won't know what criteria they'll 
have to meet to move to the next level. This ties directly into level infrastructure.

How do we implement this system?
	I can think of a few options:
		1. We use a points based system. Players complete puzzles which give them points. 
		After they accumulate enough points they are automatically prompted to move onto the
		next level. Completing puzzles with more time left on the timer will award more points. 
			Cons - This might not be reasonable on higher levels as timers get shorter. It might
			physically take longer to place certain values. 
		2. Puzzle focused approach: We track simply the number of puzzles completed within a 
		certain period of time then set that as the benchmark for completing the level. 
			I like this because it feels more concrete on a gameplay front. Instead of, "get x
			amount of points", instead it's "Complete 20 puzzles with more than a second left on
			the timer. Then we can set more tailored objectives for future levels.
			With the score system, we'd need to create the objectives then attach scores to each
			objective. Essentially doubling our work for a less engaging gameplay experience imo
			
	Levels should not be graded. I think after meeting the objective you just move on. Unless
	of course there is some lesson planning or assessment need for grading levels. Maybe could
	be graded on what objectives are or are not completed. Maybe we can use completion percenta
	-ges instead.

What will hold changing data?
	Likely the level resource. It all depends on what information changes or stays the same.
	Maybe the changes can be stored directly in the LEVEL scene over a level resource?
	
	Changes:
		Time limit
		How many puzzles were completed
		Stage responsiveness / Streaks
		VFX activity
		Lives / Tries (We want to still let players answer the puzzle if they don't get it immediately.)
	
	Stays the same:
		Multiplier
		Highest and Lowest

Level Manager:
	Handles completing levels, objectives, setting global level resources, and game states
	related to level play (STARTING, PLAYING, PAUSED, COMPLETE, INCOMPLETE). 
	
	We'll also need to handle Level start and completion.
	
	Types of Objectives: (Each level should have the ability to have a mix of level objectives)
		Complete x amount of puzzles in y time. (20 puzzles in 5 minutes)
		Complete x puzzles with y time to spare. (Endless until criteria is met.)
		Don't let timer hit 0.

We're also going to need script / scene that controls front end vfx changes like streaks and 
efficiency prompts (ie, great! Awesome!). Same goes for controlling sound too. I think this might need
to be in a seperate singleton.
"""
#endregion

func next_level():
	pass

func restart_level():
	pass

func complete_level():
	pass
	
