extends CharacterBody2D

@export var SPEED = 3000.0
@export var DIRECTION = Vector2(1, 0)

func _ready():
	$AudioStreamPlayer2D.play()

func _physics_process(delta):
	velocity = DIRECTION.normalized() * SPEED
	move_and_slide()
