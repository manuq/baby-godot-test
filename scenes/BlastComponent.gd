@tool
extends Node
class_name BlastComponent

var direction = Vector2(1, 0)

@export var frequency: Timer:
	set = set_frequency

var bullet_scene = preload("res://scenes/bullet.tscn")

func set_frequency(value):
	frequency = value
	update_configuration_warnings()

# Called when the node enters the scene tree for the first time.
func _ready():
	if frequency:
		frequency.connect("timeout", _on_timer_timeout)

func _get_configuration_warnings():
	var warnings = []
	if not get_parent() is CharacterBody2D:
		warnings.append("You can only add blast to CharacterBody2D nodes.")
	if not frequency:
		warnings.append("You must add a timer for the blast frequency.")
	return warnings

func _on_timer_timeout():
	var instance = bullet_scene.instantiate()
	if get_parent().velocity != Vector2.ZERO:
		direction = get_parent().velocity
	instance.DIRECTION = direction
	get_parent().add_child(instance)
