class_name Candle extends Area2D

var player_in_range: bool = false
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var candle_light: PointLight2D = $CandleLight

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range:
		_toggle_light()
		
func _toggle_light() -> void:
	candle_light.visible = !candle_light.visible
	if candle_light.visible:
		sprite.play("burn")
	else: 
		sprite.play("off")
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		body._show_interact_hint(true)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		body._show_interact_hint(false)
