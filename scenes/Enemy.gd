extends CharacterBody2D

enum Direction {LEFT, RIGHT, UP, DOWN}

@export var scout : bool = false
@export var scout_length : int = 0:
	set = set_scout_length

@export var speed : float = 100.0
@export var direction : Direction = Direction.RIGHT:
	set = set_direction

const  death_effect_scene = preload("res://scenes/DeathEffect.tscn")

var _direction: Vector2
var _reference_position: Vector2
var _scout_length_squared : int
var _blast: Blast
var _health: Health

func set_direction(value):
	if value == Direction.LEFT:
		_direction = Vector2.LEFT
	elif value == Direction.RIGHT:
		_direction = Vector2.RIGHT
	elif value == Direction.UP:
		_direction = Vector2.UP
	elif value == Direction.DOWN:
		_direction = Vector2.DOWN

func set_scout_length(value):
	_scout_length_squared = value * value

func _ready():
	if not _direction:
		set_direction(Direction.RIGHT)
	for n in get_children():
		if not _blast and n is Blast:
			_blast = n
		elif not _health and n is Health:
			_health = n

	%AnimatedSprite2D.flip_h = _direction.x < 0
	if _blast:
		_blast.direction = _direction.angle()
	if _health:
		_health.connect("died", _on_health_died)
		_health.connect("health_changed", _on_health_health_changed)
	if scout:
		_reference_position = position

func _physics_process(delta):
	if scout and _scout_length_squared != 0:
		if (_reference_position - position).length_squared() > _scout_length_squared:
			_direction = _direction.rotated(PI)
			if _blast:
				_blast.direction = _direction.angle()
		velocity = _direction * speed

	if velocity == Vector2.ZERO:
		%AnimatedSprite2D.animation = 'idle'
	else:
		if velocity.x != 0:
			%AnimatedSprite2D.flip_h = velocity.x < 0
		%AnimatedSprite2D.animation = 'walk'

	move_and_slide()


func _on_health_died():
	var instance = death_effect_scene.instantiate()
	instance.position = position
	add_sibling(instance)


func _on_health_health_changed(_previous, new):
	%AnimationPlayer.stop()
	%AnimationPlayer.play("hit")
	%TextureProgressBar.value = 100 * (float(new) / _health.max_health)
	%AudioStreamPlayer2D.play()
