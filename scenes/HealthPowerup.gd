extends Area2D
class_name HealthPowerup


func _on_area_entered(area):
	await get_tree().create_timer(0.1).timeout
	queue_free()
