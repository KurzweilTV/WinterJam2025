class_name Candle extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var candle_light: PointLight2D = $CandleLight
var player: Player
var is_flickering: bool = false
var interact_text: String = "Toggle Candle"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player:
		_toggle_light()
		
func _toggle_light() -> void:
	candle_light.visible = !candle_light.visible
	if candle_light.visible:
		sprite.play("burn")
		is_flickering = true
		_flicker_light()
	else: 
		sprite.play("off")
		is_flickering = false
		
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player._set_interact_text(interact_text)
		player._show_interact_hint(true)
		
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		body._show_interact_hint(false)
		
func _flicker_light() -> void:
	if not is_flickering:
		return
	
	var tween = create_tween()  # Create fresh tween each time
	tween.tween_property(candle_light, "energy", randf_range(0.7, 1.1), randf_range(0.3, 1.2))
	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
	_flicker_light()
