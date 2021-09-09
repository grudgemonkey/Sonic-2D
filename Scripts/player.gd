extends KinematicBody2D

var move_speed = 500
var grv = 100
var jump_force = 1000

var velocity : Vector2
var input_vector : Vector2

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if input_vector.x != 0:
		velocity.x = input_vector.x * move_speed
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("ui_accept"):
		velocity.y = jump_force
	
	velocity.y += grv
	
	print(velocity)
	move_and_slide(velocity)
	
