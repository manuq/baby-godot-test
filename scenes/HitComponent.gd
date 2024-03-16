@tool
extends Area2D
class_name HitComponent

@export var health : HealthComponent:
	set = set_health

func set_health(value):
	health = value
	update_configuration_warnings()

func _get_configuration_warnings():
	var warnings = []
	if not health:
		warnings.append("You must setup a HealthComponent.")
	return warnings

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	body.queue_free()
	health.got_hit()
