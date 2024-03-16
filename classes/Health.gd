@tool

@icon("res://classes/Health.svg")

## Take care of your health!
class_name Health extends Node

## This is emited when you die.
signal died

## This is emited when the health changes.
signal health_changed(value: int)

## How much health to start?
@export_range(0, 5, 1) var max_health : int = 5

## If provided, it will be used to wait until the next harm. For example, for avatar recovering time.
@export var recovering_timer: Timer

var _health : int

func _ready():
	_health = max_health

## Return current health.
func get_health():
	return _health

## Call this to heal.
func heal():
	var previous_health = _health
	_health = max_health
	health_changed.emit(previous_health, _health)

## Call this to lower the health by one. Warning you can die!
func got_hit():
	if recovering_timer and recovering_timer.time_left != 0:
		return
	var previous_health = _health
	if _health > 0:
		_health -= 1
		health_changed.emit(previous_health, _health)
	if recovering_timer:
		recovering_timer.start()
	if _health == 0:
		died.emit()
		get_parent().queue_free()
