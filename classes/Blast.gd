@tool

@icon("res://classes/Blast.svg")

## You can now blast!
class_name Blast extends Node2D

## Where to blast.
@export_range(-360, 360, 0.1, "radians_as_degrees") var direction: float


## The default direction if none is set and character is not moving:
const DEFAULT_DIRECTION = 0.0

## If set, overrides the bullet speed.
@export var bullet_speed: float

## This is the bullet.
@export var bullet_scene: PackedScene: # Bullet
	set = set_bullet_scene

var _frequency: Timer

func set_frequency(value):
	_frequency = value
	_frequency.connect("timeout", _on_timer_timeout)
	update_configuration_warnings()

func set_bullet_scene(value):
	bullet_scene = value
	update_configuration_warnings()

func _try_set_frequency(_node):
	if _frequency:
		return
	for n in get_children():
		if n is Timer:
			set_frequency(n)
			break

func _try_unset_frequency(node):
	if _frequency == node:
		_frequency = null
		update_configuration_warnings()

func _init():
	child_entered_tree.connect(_try_set_frequency)
	child_exiting_tree.connect(_try_unset_frequency)
	_try_set_frequency(null)

func _get_configuration_warnings():
	var warnings = []
	if not get_parent() is Node2D:
		warnings.append("You can only add blast to Node2D nodes.")
	if not _frequency:
		warnings.append("You must add a timer as children for the blast frequency.")
	if not bullet_scene:
		warnings.append("You must setup a bullet scene.")
	return warnings

func _process(delta):
	pass
	#if Engine.is_editor_hint():
		#queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_colored_polygon(PackedVector2Array([Vector2(0, 0), Vector2(64, -64), Vector2(104, -32), Vector2(192, 0), Vector2(104, 32), Vector2(64, 64)]), Color("#ff0000", 0.2))

func _on_timer_timeout():
	do_blast()

## Call this to blast manually.
func do_blast():
	if not bullet_scene: # or not bullet_scene is Bullet:
		return
	var instance = bullet_scene.instantiate()
	if bullet_speed:
		instance.speed = bullet_speed

	if direction:
		instance.direction = direction + global_rotation
	elif get_parent() is CharacterBody2D and get_parent().velocity != Vector2.ZERO:
		instance.direction = get_parent().velocity.angle() + global_rotation
	else:
		# instance.direction = Vector2.RIGHT.rotated(get_parent().rotation)
		instance.direction = DEFAULT_DIRECTION + global_rotation
	instance.position = get_parent().global_position + position
	get_tree().root.add_child(instance)
