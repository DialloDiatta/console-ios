extends Resource
class_name Level

@export var level_name: String
@export var level_id: String

## The scene players will be sent to.
@export_file("*.tscn") var scene_path: String
@export var lowest: int = 1 #Default values to avoid errors.
@export var highest: int = 2

@export var wait_time: float = 5.0

@export var goal: int = 10
