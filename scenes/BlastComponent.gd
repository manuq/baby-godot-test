@tool
extends Node
class_name BlastComponent

var direction = Vector2(1, 0)

@export var frequency: Timer:
	set = set_frequency

@export var bullet_scene: PackedScene:
	set = set_bullet_scene
	
func set_frequency(value):
	frequency = value
	update_configuration_warnings()

func set_bullet_scene(value):
	bullet_scene = value
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
		warnings.append("You must setup a timer for the blast frequency.")
	if not bullet_scene:
		warnings.append("You must setup a bullet scene.")
	return warnings

func _on_timer_timeout():
	if not bullet_scene:
		return
	var instance = bullet_scene.instantiate()
	if get_parent().velocity != Vector2.ZERO:
		direction = get_parent().velocity
	instance.DIRECTION = direction
	get_parent().add_child(instance)
