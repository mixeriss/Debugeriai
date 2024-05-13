extends CanvasLayer

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
	
func updateScore(points):
	$ColorRect/Label2.text = str(points)
	pass
