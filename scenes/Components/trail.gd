extends Line2D

var queue : Array
@export var MAX_LENGTH : int

# TODO If the pos hasn't changed in "period of time" remove the point. 
func _process(_delta: float) -> void:
	if Global.trail_on:
		var pos = get_global_mouse_position()
		
		queue.push_front(pos)
		
		if queue.size() > MAX_LENGTH:
			queue.pop_back()
		
		clear_points()
		
		for point in queue:
			add_point(point)
	else:
		clear_points()
