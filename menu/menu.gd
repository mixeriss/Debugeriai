extends Control

func _ready():
	$VBoxContainer/StartButton.grab_focus()
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Game/Game.tscn")
	pass

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://menu/options_menu.tscn")
	pass

func _on_quit_button_pressed():
	get_tree().quit()
	pass

func _on_back_pressed():
	pass # Replace with function body.
