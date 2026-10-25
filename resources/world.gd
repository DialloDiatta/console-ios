class_name World extends Resource

@export var name: String
@export var id: String
@export var levels: Array[Level]

# TODO Have the scene path for levels live in the world resource instead of the level.
# All levels in a world can get there scene path from the world resource.
# But honestly, if we want to switch up and go back and forth between different scenes in a 
# single world, it would be better to leave the scene path in the level resourc.
# PLUS, i won't have to change anything ¯\_(ツ)_/¯
#@export var scene_path
