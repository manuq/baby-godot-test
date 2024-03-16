@tool

@icon("res://classes/Hitbox.svg")

## Avoid getting hit!
class_name Hitbox extends Area2D

## This is emited when you get a hit.
signal got_hit

## If provided, this will get the harm and a powerup will heal it.
@export var health : Health:
	set = set_health

## Optionally, pass a blast that will be charged with a powerup.
@export var blast : Blast

func set_health(value):
	health = value
	update_configuration_warnings()

func _get_configuration_warnings():
	var warnings = []
	return warnings

func _ready():
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)
	if health:
		connect("got_hit", health.got_hit)


func _on_body_entered(body):
	## This is when a bullet body enters.
	body.queue_free()
	do_hit()


func _on_area_entered(area):
	## This is when 2 shapes collide (eg avatar shape and enemy shape)
	if area is HealthPowerup:
		if health:
			health.heal()
			return
		else:
			return
	do_hit()


func do_hit():
	got_hit.emit()
