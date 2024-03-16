extends CharacterBody2D

@export var SPEED = 500.0

func _physics_process(delta):
	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = 'idle'
	else:
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.animation = 'walk'

	move_and_slide()
