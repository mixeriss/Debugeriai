extends Control

var paused
# Called when the node enters the scene tree for the first time.
func _ready():
	paused = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_pause_pressed():
	var canvas = $"../.."
	var transform = canvas.transform
	transform.origin = Vector2(20, 110);
	canvas.transform = transform
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
