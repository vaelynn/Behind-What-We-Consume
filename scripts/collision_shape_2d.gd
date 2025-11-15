extends CollisionShape2D

@export var player: Node2D   # drag your player node here in the Inspector

func _process(delta: float) -> void:
	if player:
		global_position = player.global_position

# Inside WorldBoundary.gd
