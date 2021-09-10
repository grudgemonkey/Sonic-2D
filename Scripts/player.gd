extends KinematicBody2D

enum {
	ON_GROUND,
	IN_AIR,
	ROLLING
}

var move_speed = 30
var grv = 100
var jump_force = 1500
var acc = 50
var max_speed = 1000
var run_threshold = 950

var state = IN_AIR

var velocity : Vector2
var input_vector : Vector2

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	 
	
	match state:
		IN_AIR:
			if input_vector.x != 0:
				velocity.x = input_vector.x * move_speed
				if input_vector.x < 0:
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
			
			velocity.y += grv
			if $RayCast2D.is_colliding():
				state = ON_GROUND
		ROLLING:
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				if $RayCast2D.is_colliding():
					state = ON_GROUND
			else:
				velocity.y += grv
			$AnimatedSprite.play("Spin")
		ON_GROUND:
			if input_vector.x != 0:
				move_speed += acc
				velocity.x = input_vector.x * move_speed
				if move_speed >= run_threshold:
					$AnimatedSprite.play("Run")
				else:
					$AnimatedSprite.play("Walk")
				if move_speed >= max_speed:
					move_speed = max_speed
				if input_vector.x < 0:
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
				
				if Input.is_action_just_pressed("down"):
					state = ROLLING
			else:
				move_speed = 30
				velocity.x = 0
				$AnimatedSprite.play("Idle")
			
			velocity.y = 0
			
			if Input.is_action_just_pressed("jump"):
				state = IN_AIR
				velocity.y = -jump_force
				$AnimatedSprite.play("Spin")
				$JumpSound.play()
			
			if $RayCast2D.is_colliding() == false:
				state = IN_AIR
	
	print(move_speed)
	move_and_slide(velocity)
