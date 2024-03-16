@tool

@icon("res://classes/Blast.svg")

## You can now blast!
class_name Blast extends Node

## Where to blast.
@export var direction: Vector2

## The default direction if none is set and character is not moving:
const DEFAULT_DIRECTION = Vector2(1, 0)

## If set, overrides the bullet speed.
@export var bullet_speed: float

## This is the bullet.
@export var bullet_scene: PackedScene:
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

func _init():
	child_entered_tree.connect(_try_set_frequency)
	child_exiting_tree.connect(_try_unset_frequency)
	_try_set_frequency(null)

func _get_configuration_warnings():
	var warnings = []
	if not get_parent() is CharacterBody2D:
		warnings.append("You can only add blast to CharacterBody2D nodes.")
	if not _frequency:
		warnings.append("You must add a timer as children for the blast frequency.")
	if not bullet_scene:
		warnings.append("You must setup a bullet scene.")
	return warnings

func _on_timer_timeout():
	do_blast()

## Call this to blast manually.
func do_blast():
	if not bullet_scene: # or not bullet_scene.is_class("Bullet"):
		return
	var instance = bullet_scene.instantiate()
	if bullet_speed:
		instance.speed = bullet_speed

	if direction:
		instance.direction = direction
	elif get_parent().velocity != Vector2.ZERO:
		instance.direction = get_parent().velocity
	else:
		instance.direction = DEFAULT_DIRECTION
	instance.position = get_parent().global_position
	get_tree().root.add_child(instance)
