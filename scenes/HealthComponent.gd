@tool
extends Node
class_name HealthComponent

@export_range(0, 5, 1) var MAX_HEALTH : int = 5

var health : int

func _ready():
	health = MAX_HEALTH

func got_hit():
	if health > 0:
		health -= 1
	if health == 0:
		get_parent().queue_free()
