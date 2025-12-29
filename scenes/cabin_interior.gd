class_name World extends Node2D

const DIALOG_BOX_SCENE = preload("res://ui/dialog_box.tscn")

@export var disable_power_outage_event: bool = true #disable power outage for debug
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ui: CanvasLayer = $UI

func _ready() -> void:
	launch_power_event()
	
func _toggle_power(toggle: bool) -> void:
	#TODO Play Click Sound
	print("Power: %s" % toggle)
	canvas_modulate.visible = !toggle

func launch_power_event() -> void:
	if disable_power_outage_event: return
	await get_tree().create_timer(3.0).timeout
	_toggle_power(false)
	await get_tree().create_timer(2.0).timeout
	var dialogbox = DIALOG_BOX_SCENE.instantiate()
	ui.add_child(dialogbox)
	dialogbox.show_messages([
	"Oh no... the power went out!",
	"I should light some candles.",
	"Maybe the \"F\" key will work..."] as Array[String])
