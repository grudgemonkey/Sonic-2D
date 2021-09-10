extends Control



func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Zones/testzone.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/Menus/creditsscreen.tscn")
