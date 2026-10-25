extends Node

var worlds: Array[World] # Populate with all relevant world resouce paths.

var current_world_resource: World:
		set(value):
			current_world_resource = value
			if current_world_resource:
				print("World Resource Set: ", current_world_resource.name)
				print("World Levels: ")
				for level in current_world_resource.levels:
					print(level.level_name)
			else:
				push_error("No World Resource Set. Assign 'World' to WorldButton")
var current_level_index: int = 0

var current_level_resource: Level:
	get:
		if current_world_resource == null:
			push_error("No World Resource Set.")
			return null
		return current_world_resource.levels[current_level_index]

func _ready() -> void:
	# TODO Remove later. 👇 This is for when the single console is the main scene.
	set_world(load("res://resources/world_1.tres"), 0)
	
func set_world(world: World, starting_index: int):
	current_world_resource = world
	current_level_index = starting_index

func has_next_level():
	return current_level_index < current_world_resource.levels.size() - 1

func next_level(): # We want to make sure to only call this once.
	current_level_index = mini(current_level_index + 1, current_world_resource.levels.size() - 1)
	
func prev_level():
	current_level_index = maxi(current_level_index - 1, 0)

func restart_level(): # Connect to proper signal later.
	pass

func complete_level(): # Connect to proper signal later.
	pass

func save_level():
	pass

func next_world():
	pass
