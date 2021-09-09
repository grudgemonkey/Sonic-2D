extends KinematicBody2D

enum {
	ON_GROUND,
	IN_AIR,
	ROLLING
}

var move_speed = 500
var grv = 100
var jump_force = 1500

var state = IN_AIR

var velocity : Vector2
var input_vector : Vector2

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
#	if 
	
	match state:
		IN_AIR:
			velocity.y += grv
			if $RayCast2D.is_colliding():
				state = ON_GROUND
		ROLLING:
			$AnimatedSprite.play("Spin")
		ON_GROUND:
			if input_vector.x != 0:
				velocity.x = input_vector.x * move_speed
				$AnimatedSprite.play("Walk")
				if input_vector.x < 0:
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
			else:
				velocity.x = 0
				$AnimatedSprite.play("Idle")
			
			velocity.y = 0
			
			if Input.is_action_just_pressed("jump"):
				state = IN_AIR
				velocity.y = -jump_force
				$AnimatedSprite.play("Spin")
			
			if $RayCast2D.is_colliding() == false:
				state = IN_AIR
	
	print(state)
	move_and_slide(velocity)
