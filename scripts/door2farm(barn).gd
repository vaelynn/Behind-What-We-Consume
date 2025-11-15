extends Area2D
@export var target_scene: String = "res://flow/scene_3.tscn"

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player touched portal! Teleporting...")
		get_tree().change_scene_to_file(target_scene)


func _teleport_player():
	get_tree().change_scene_to_file(target_scene)
