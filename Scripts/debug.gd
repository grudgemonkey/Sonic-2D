extends Control

var player = load("res://Scenes/Actors/player.tscn")

func _process(delta):
	$ColorRect/movespeed.text = str(player.move_speed)
