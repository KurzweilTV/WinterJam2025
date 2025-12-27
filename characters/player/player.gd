extends CharacterBody2D

@export var speed = 50
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Track last direction for idle facing
var last_direction: Vector2 = Vector2.DOWN

func get_input():
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	set_animation(input_direction)

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
