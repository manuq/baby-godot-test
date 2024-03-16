extends CharacterBody2D

@export var speed = 800.0

signal lives_changed(value: int)

const  death_effect_scene = preload("res://scenes/DeathEffect.tscn")


func _get_axis(v: Vector2):
	if abs(v.x) > abs(v.y):
		return Vector2(v.x, 0)
	else:
		return Vector2(0, v.y)


func _is_flipped_axis(v1: Vector2, v2: Vector2):
	if v1.x == 0 and v2.x == 0 and ((v1.y < 0 and v2.y > 0) or (v1.y > 0 and v2.y < 0)):
			return true
	elif v1.y == 0 and v2.y == 0 and ((v1.x < 0 and v2.x > 0) or (v1.x > 0 and v2.x < 0)):
			return true
	return false

func _physics_process(delta):
	if Input.is_action_pressed("ui_select"):
		if %FrequencyTimer.is_stopped():
			%Blast.do_blast()
			%FrequencyTimer.start()
	else:
		%FrequencyTimer.stop()
		
	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * speed * 0.5
	else:
		velocity.y = move_toward(velocity.y, 0, speed * 0.5)

	if velocity == Vector2.ZERO:
		%AnimatedSprite2D.animation = 'idle'
	else:
		var axis = _get_axis(velocity)
		if not Input.is_action_pressed("ui_select"):
			%Blast.direction = axis
		elif _is_flipped_axis(axis, _get_axis(%Blast.direction)):
			%Blast.direction = axis
		if velocity.x != 0:
			%AnimatedSprite2D.flip_h = velocity.x < 0
		%AnimatedSprite2D.animation = 'walk'

	move_and_slide()


func _on_health_died():
	var instance = death_effect_scene.instantiate()
	instance.position = position
	add_sibling(instance)


func _on_health_health_changed(previous, new):
	%AnimationPlayer.stop()
	if new < previous:
		%AudioStreamPlayer2D.play()
		%AnimationPlayer.play("hit")
	else:
		%AudioStreamPlayer2D2.play()
		%AnimationPlayer.play("heal")
	lives_changed.emit(new)
