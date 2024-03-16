extends CharacterBody2D

@export var SPEED = 100.0
@export var DIRECTION = Vector2(1, 0)

func _physics_process(delta):
	velocity = DIRECTION * SPEED

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = 'idle'
	else:
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.animation = 'walk'

	move_and_slide()
