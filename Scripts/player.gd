extends KinematicBody2D

enum {
	ON_GROUND,
	IN_AIR,
	JUMPING,
	ROLLING,
	GRINDING
}

var move_speed = 40
var grv = 100
var jump_force = 1500
var acc = 10
var max_speed = 1000
var run_threshold = 950
var frc = 300

var state = IN_AIR

var velocity : Vector2
var input_vector : Vector2

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	 
	match state:
		JUMPING:
			$AnimatedSprite.play("Spin")
			velocity.y += grv
			if $RayCast2D.is_colliding():
				state = ON_GROUND
		GRINDING:
			$AnimatedSprite.play("Idle")
			velocity.x = move_speed
			velocity.y = 0
			if Input.is_action_just_pressed("jump"):
				velocity.y -= jump_force
				state = JUMPING
		IN_AIR:
			velocity.y += grv
			if $RayCast2D.is_colliding():
				state = ON_GROUND
		ROLLING:
			$AnimatedSprite.play("Spin")
			move_speed -= frc
			if move_speed == 0:
				state = ON_GROUND
			if $RayCast2D.is_colliding() == false:
				state = IN_AIR
		ON_GROUND:
			if input_vector.x != 0:
				$AnimatedSprite.play("Walk")
				if input_vector.x < 0:
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
				move_speed += acc
				velocity.x = input_vector.x * move_speed
			else:
				$AnimatedSprite.play("Idle")
				move_speed = 40
				velocity.x = 0
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				state = JUMPING
			
			if $RayCast2D.is_colliding() == false:
				state = IN_AIR
			
			if Input.is_action_just_pressed("down"):
				state = ROLLING
	
	move_and_slide(velocity)


func _on_GrindRail_body_entered(body):
	state = GRINDING
	print("is geinding")
