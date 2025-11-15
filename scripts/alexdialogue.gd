extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var dialogue_running := false
var dialogue_done := false
var active_player: player = null  # Type hint

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if dialogue_running or dialogue_done:
		return

	if body.is_in_group("player"):
		var p = body as player
		if p == null:
			return
		active_player = p
		_start_dialogue(active_player)

func _start_dialogue(p: player):
	dialogue_running = true
	dialogue_done = true

	# Stop the player and force idle animation
	p.can_move = false
	p.anim_sprite.play("idle front")

	# Show dialogue balloon
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)

	if balloon:
		_connect_to_balloon(balloon)
	else:
		_on_dialogue_finished()

func _connect_to_balloon(balloon):
	var possible_signals = [
		"dialogue_finished",
		"dialogue_ended",
		"finished",
		"closed",
		"dialogue_closed"
	]

	for s in possible_signals:
		if balloon.has_signal(s):
			balloon.connect(s, _on_dialogue_finished)
			print("Connected to dialogue signal:", s)
			return

	print("No valid dialogue signal found — using fallback")
	_on_dialogue_finished()

func _on_dialogue_finished():
	dialogue_running = false

	if active_player:
		# Restore player movement
		active_player.can_move = true
		active_player = null
