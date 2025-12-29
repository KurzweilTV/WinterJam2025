class_name InteractionPoint extends Area2D

const DIALOG_BOX_SCENE = preload("res://ui/dialog_box.tscn")
@export var collision: CollisionShape2D
@export var hint_text: String = ""
@export var interact_dialog: Array[String]
var player: Player
@onready var ui: CanvasLayer = $CanvasLayer

func _ready() -> void:
	assert(collision.shape != null, "Set the collision shape on %s" % name)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player:
		player._show_interact_hint(false)
		show_dialog(interact_dialog)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		body._set_interact_text(hint_text)
		body._show_interact_hint(true)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		body._show_interact_hint(false)

func show_dialog(dialog: Array) -> void:
	var dialogbox = DIALOG_BOX_SCENE.instantiate() as DialogBox
	ui.add_child(dialogbox)
	dialogbox.show_messages(dialog)
