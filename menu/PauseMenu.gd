extends Control

@onready var Game = $"../../"


func _on_resume_pressed():
	$Click.play()
	Game.pauseMenu()
	pass # Replace with function body.


func _on_back_to_menu_pressed():
	$Click.play()
	get_tree().change_scene_to_file("res://menu/menu.tscn")
	Game.pauseMenu()
	pass # Replace with function body.


func _on_exit_game_pressed():
	$Click.play()
	get_tree().quit()
	pass # Replace with function body.
