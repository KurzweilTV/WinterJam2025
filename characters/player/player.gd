extends CharacterBody2D

@export var speed = 50
var last_direction: Vector2 = Vector2.DOWN # Track last direction for idle facing
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var candle_light: PointLight2D = $CandleLight

func get_input():
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	set_animation(input_direction)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_candle"):
		toggle_candle()

func _physics_process(_delta):
	get_input()
	move_and_slide()

func set_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		animated_sprite_2d.play("idle")
		return

	last_direction = direction

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite_2d.play("walk_right")
		else:
			animated_sprite_2d.play("walk_left")
	else:
		if direction.y > 0:
			animated_sprite_2d.play("walk_down")
		else:
			animated_sprite_2d.play("walk_up")

func toggle_candle() -> void:
	candle_light.visible = !candle_light.visible
	#TODO Candle Sounds
