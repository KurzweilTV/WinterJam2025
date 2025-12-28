class_name DialogBox extends NinePatchRect

@export var character_speed: float = 20.0
@export var rest_position_y: float = 114.0
@export var off_screen_y: float = 200.0
@export var slide_duration: float = 0.4

@onready var label: Label = $MarginContainer/Label
@onready var sound_player: AudioStreamPlayer = $AudioStreamPlayer

var message_queue: Array[String] = []
var current_message_index: int = 0
var is_typing: bool = false
var current_text: String = ""

func _ready() -> void:
	Signals.dialog_open.emit()
	label.text = ""
	label.visible_characters = 0
	
	# Start off-screen
	position.y = off_screen_y
	
	# Slide in with bounce
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)  # Creates bounce effect
	tween.tween_property(self, "position:y", rest_position_y, slide_duration)

func show_messages(messages: Array[String]) -> void:
	message_queue = messages
	current_message_index = 0
	_show_next_message()

func _show_next_message() -> void:
	if current_message_index >= message_queue.size():
		await _slide_out()
		queue_free()
		return
	
	current_text = message_queue[current_message_index]
	label.text = current_text
	label.visible_characters = 0
	is_typing = true
	start_typewriter(current_text)

func _slide_out() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", off_screen_y, slide_duration)
	await tween.finished
	Signals.dialog_closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	var is_new_key_press = event is InputEventKey and event.pressed and not event.echo
	var is_mouse_click = event is InputEventMouseButton and event.pressed
	
	if is_new_key_press or is_mouse_click:
		if is_typing:
			label.visible_characters = len(current_text)
			is_typing = false
		else:
			current_message_index += 1
			_show_next_message()
		get_viewport().set_input_as_handled()

func start_typewriter(full_text: String) -> void:
	for i in range(len(full_text) + 1):
		if not is_typing:
			return
		
		label.visible_characters = i
		
		if i > 0 and full_text[i - 1] != " ":
			sound_player.pitch_scale = randf_range(0.78, 0.8)
			sound_player.play()
		
		await get_tree().create_timer(1.0 / character_speed).timeout
	
	is_typing = false
