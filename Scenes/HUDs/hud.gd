extends Control

var rings : int

func _process(delta):
	$Label.text = "RINGS:" + str(rings)
