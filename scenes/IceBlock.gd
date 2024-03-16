extends StaticBody2D


const  death_effect_scene = preload("res://scenes/DeathEffect.tscn")


func _on_health_died():
	var instance = death_effect_scene.instantiate()
	instance.position = position
	add_sibling(instance)

func _on_health_health_changed(_previous, _new):
	%AnimationPlayer.stop()
	%AnimationPlayer.play("hit")
