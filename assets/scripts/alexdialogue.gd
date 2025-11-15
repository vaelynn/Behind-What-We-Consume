extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var dialogue_done: bool = false
var dialogue_running: bool = false
var active_player: player = null

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if dialogue_done or dialogue_running:
		return
	if body.is_in_group("player"):
		var p = body as player
		if p == null:
			return
		active_player = p
		_start_dialogue(active_player)

func _start_dialogue(p: player) -> void:
	dialogue_running = true
	dialogue_done = true

	p.can_move = false  # freeze player during dialogue

	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

	# Safe Godot 4 connection — only 2 args
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_finished):
		DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	dialogue_running = false

	if active_player != null:
		active_player.can_move = true  # unfreeze player
		active_player = null

	# Disconnect to make it “one-shot”
	if DialogueManager.dialogue_ended.is_connected(_on_dialogue_finished):
		DialogueManager.dialogue_ended.disconnect(_on_dialogue_finished)
