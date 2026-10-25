extends Control

@onready var blur: ColorRect = $Blur
@onready var box: PanelContainer = $Blur/Box
@onready var buttons: HBoxContainer = $Blur/Buttons
@onready var replay: Button = $Blur/Buttons/Replay
@onready var next: Button = $Blur/Buttons/Next
@onready var title: RichTextLabel = $Blur/Box/VBoxContainer/Title

@onready var info_container: VBoxContainer = %InfoContainer
@onready var info_cell: HBoxContainer = %InfoCell


func _ready() -> void:
	reset()
	Signals.end_level.connect(on_level_ended)
	
func on_level_ended(completed: int, reach_goal: bool):
	show()
	get_tree().paused = true
	info_cell.stat.text = str(completed)
	
	if !reach_goal:
		next.queue_free()
		title.text = "Try Again (●◡●)"
	else:
		title.text = "Nice Job! XD 👍"
	
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(blur, "modulate:a", 1.0, 0.5).from(0.0)
	tween.tween_property(box, "position:y", box.position.y - 50, 0.5).from(box.position.y + 50)
	await tween.finished
	
	var button_tween := create_tween()
	button_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	for button in buttons.get_children():
		button.show()
		button_tween.set_parallel()
		button_tween.tween_property(button, "modulate:a", 1.0, 0.3).from(0.0)
		button_tween.tween_property(button, "position:y", button.position.y - 25, 0.4).from(button.position.y + 25)
	await button_tween.finished
	
	#info_container.add_child(info_cell.duplicate())

func reset():
	hide()
	for button in buttons.get_children():
		button.hide()

func _on_replay_pressed() -> void:
	get_tree().paused = false
	SceneManager.reload_scene()


func _on_next_pressed() -> void:
	get_tree().paused = false
	if Levels.has_next_level():
		Levels.next_level()
		SceneManager.reload_scene()
		print("Next Up: ", Levels.current_level_resource.level_name)
	else:
		# TODO Logic for after getting to the end of a world. 
		print("End of Levels in %s." % [Levels.current_world_resource.name])
		title.text = "All Levels Completed ⌐■_■)"
		next.text = "Return to Lobby"
		SceneManager.change_scene("res://scenes/Lobby/lobby.tscn")
