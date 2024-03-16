extends Node2D


func _on_audio_stream_player_2d_finished():
	queue_free()


func _on_animated_sprite_2d_animation_finished():
	%AnimatedSprite2D.visible = false
