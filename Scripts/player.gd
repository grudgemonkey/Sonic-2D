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
var min_speed = 40
var run_threshold = 950
var frc = 20

var rings : int = 0
var points : int = 0

var state = IN_AIR

var velocity : Vector2
var input_vector : Vector2

var direction : int = 1

func _ready():
	pass #$AnimatedSprite.speed_scale = 0.5

func _process(delta):
	$Camera2D/HUD.rings = rings
	debug()

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
#	$AnimatedSprite.speed_scale *= move 
	
	match state:
		JUMPING:
			$AnimatedSprite.play("Spin")
			velocity.y += grv
			velocity.x = input_vector.x * move_speed
			if Input.is_action_just_pressed("jump"):
				insta_shield()
			if $RayCast2D.is_colliding():
				state = ON_GROUND
		GRINDING:
			$AnimatedSprite.play("Idle")
			velocity.x = move_speed
			velocity.y = 0
			if Input.is_action_just_pressed("jump"):
				velocity.y -= jump_force
				state = JUMPING
			if $RayCast2D.is_colliding():
				state = ON_GROUND
			print("is_grinding")
		IN_AIR:
			velocity.y += grv
			if $RayCast2D.is_colliding():
				state = ON_GROUND
		ROLLING:
			$AnimatedSprite.play("Spin")
			move_speed -= frc
#			if move_speed <= 0:
#				move_speed = 0
#				if move_speed == 0:
#					state = ON_GROUND
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				$JumpSound.play()
				state = JUMPING
			if $RayCast2D.is_colliding() == false:
				state = IN_AIR
		ON_GROUND:
			if input_vector.x != 0:
				$AnimatedSprite.play("Walk")
				if input_vector.x < 0:
					$AnimatedSprite.flip_h = true
					direction = -1
				else:
					$AnimatedSprite.flip_h = false
					direction = 1
				
				if Input.is_action_just_pressed("down"):
					state = ROLLING
				
				move_speed += acc
				velocity.x = input_vector.x * move_speed
				
				if move_speed >= run_threshold:
					$AnimatedSprite.play("Run")
				else:
					$AnimatedSprite.play("Walk")
			else:
				$AnimatedSprite.play("Idle")
#				move_speed = 0
#				velocity.x = 0
				move_speed -= min(abs(move_speed), frc) * sign(move_speed)
				velocity.x = direction * move_speed
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = -jump_force
				$JumpSound.play()
				state = JUMPING
			
			if Input.is_action_pressed("down"):
				pass
			
			if $RayCast2D.is_colliding() == false:
				state = IN_AIR
	
	print("vel:" + str(velocity.x))
	print("gsp:" + str(move_speed))
	move_and_slide(velocity)

func insta_shield() -> void:
	print("insta-shield")

func stats() -> void:
	pass

func debug() -> void:
	$Camera2D/HUD.move_speed = move_speed
	$Camera2D/HUD.velocity = velocity.x
	$Camera2D/HUD.direction = direction

func _on_GrindRail_body_entered(body):
	state = GRINDING
	print("is geinding")


func _on_Ring__on_Ring_collected():
	rings += 1
