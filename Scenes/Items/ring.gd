extends Area2D

func _ready():
	$AnimatedSprite.play()

signal _on_Ring_collected()

func _on_Ring_body_entered(body):
	$AudioStreamPlayer.play()
	visible = false
	remove_child($CollisionShape2D)
	emit_signal("_on_Ring_collected")
