extends Node2D

var ring
export var amount : int 

func _ready():
	ring = load("res://Scenes/Items/ring.tscn")
	add_child(ring)
	$Ring/AnimatedSprite.play("default")
	

func _process(delta):
	pass

func _on_Ring_body_entered(body):
	$Ring/AudioStreamPlayer.play()
	$Ring.visible = false
	$Ring.remove_child($Ring/CollisionShape2D)
	

