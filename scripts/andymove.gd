extends CharacterBody2D
class_name player

@export var speed: float = 130.0
@onready var anim_sprite: AnimatedSprite2D = $animation

var can_move: bool = true  # Set false to stop player

func _physics_process(_delta: float) -> void:
	# If player cannot move, stop completely
	if not can_move:
		speed = 0
		velocity = Vector2.ZERO
		anim_sprite.play("idle front")
		move_and_slide()
		return

	# Normal movement
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_dir * speed
	move_and_slide()

	# Animations
	if input_dir != Vector2.ZERO:
		anim_sprite.play("walk")
		anim_sprite.flip_h = input_dir.x > 0
	else:
		anim_sprite.play("idle front")
