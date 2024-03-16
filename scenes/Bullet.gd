extends CharacterBody2D

class_name Bullet

@export var speed = 3000.0
@export var direction = Vector2(1, 0)


func _ready():
	$AudioStreamPlayer2D.play()


func _physics_process(delta):
	if is_on_wall():
		await get_tree().create_timer(0.1).timeout
		queue_free()

	velocity = direction.normalized() * speed
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
