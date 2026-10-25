extends Node

signal group_activated
signal group_deactivated

signal start_game
signal end_level(completed: int, reach_goal: bool)

signal assign_level_resource(level: Level)

signal base_changed

signal clear

signal move_camera(to_target: Node)

signal deselect_world
signal select_world

signal correct

signal start_streak
signal end_streak()
