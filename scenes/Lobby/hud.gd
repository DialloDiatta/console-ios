extends CanvasLayer

@onready var pop_up: PanelContainer = $PopUp

# TODO Replace after animating and completing design.
@onready var title: RichTextLabel = %Title
@onready var level_select_button: PackedScene = preload("res://scenes/Lobby/level_select_button.tscn")
@onready var select_container: VBoxContainer = %SelectContainer


@onready var fade: TextureRect = $Fade

var tween: Tween

func _ready() -> void:
	pop_up.hide()
	fade.hide()
	Signals.select_world.connect(_on_select_world)
	Signals.deselect_world.connect(_on_deselect_world)
	
	for b in $VBoxContainer.get_children():
		b.pressed.connect(func():
			pass
			)

func _on_select_world():
	
	await get_tree().create_timer(0.2).timeout
	populate() # Populate is placed here to give time for the resource to load and camera move.
	pop_up.show()
	fade.show()
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	tween.tween_property(pop_up, "modulate:a", 1.0, 0.5).from(0.0)
	tween.tween_property(pop_up, "position:y", 165.0, 0.7).from(pop_up.position.y - 50) # 50 is the offset.
	tween.tween_property(fade, "modulate:a", 1.0, 0.5).from(0.0)
	
func _on_deselect_world():
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	tween.tween_property(pop_up, "modulate:a", 0.0, 0.5)
	tween.tween_property(fade, "modulate:a", 0.0, 0.5)
	await tween.finished
	pop_up.modulate.a = 1.0
	pop_up.hide()
	fade.hide()

func populate():
	# Empty Container
	for i in select_container.get_children():
		i.queue_free()
	
	title.text = Levels.current_world_resource.name
	var world_array = Levels.current_world_resource.levels
	for level in world_array:
		var button = level_select_button.instantiate()
		var button_index = world_array.find(level)
		
		button.text = level.level_name
		select_container.add_child(button)
		
		button.pressed.connect(func():
			SceneManager.change_scene(level.scene_path, {"delay_time" : 0.5})
			Levels.current_level_index = button_index
			print("Button Index: ", button_index)
			)
