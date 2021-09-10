extends Area2D

func _ready():
	$AnimatedSprite.play()

func _on_Ring_body_entered(body):
	$AudioStreamPlayer.play()
	visible = false
	remove_child($CollisionShape2D)
