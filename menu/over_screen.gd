extends CanvasLayer

const SAVE = "res://file.save"
var highestScore = 0

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func showScore(points):
	$ColorRect/Score.text = "Score: " + str(points)
	loadScore()
	$ColorRect/HighestScore.text = "Highest score: " + str(highestScore)
	if points >= highestScore:
		highestScore = points
		$ColorRect/HighestScore.text = "Highest score: " + str(points)
		saveScore()
	pass
func loadScore():
	var file = FileAccess.open(SAVE, FileAccess.READ)
	if FileAccess.file_exists(SAVE):
		highestScore = file.get_32()		
		
func saveScore():
	var file = FileAccess.open(SAVE, FileAccess.WRITE_READ)
	file.store_32(highestScore)
