extends Control

var rings : int
var move_speed
var velocity
var direction

func _process(delta):
	$Label.text = "RINGS:" + str(rings) #+ "  speed:" + str(move_speed)
