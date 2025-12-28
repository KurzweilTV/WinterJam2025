extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ui: CanvasLayer = $UI

const DIALOG_BOX_SCENE = preload("res://ui/dialog_box.tscn")

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	_toggle_power(false)
	await get_tree().create_timer(2.0).timeout
	
	var dialogbox = DIALOG_BOX_SCENE.instantiate()
	ui.add_child(dialogbox)  # Move this BEFORE show_messages
	dialogbox.show_messages([
		"Oh no... the power went out!",
		"I should light some candles.",
		"Maybe the \"F\" key will work...",
	] as Array[String])
	
func _toggle_power(toggle: bool) -> void:
	#TODO Play Click Sound
	print("Power: %s" % toggle)
	canvas_modulate.visible = !toggle
