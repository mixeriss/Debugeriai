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
	if paused == false:
		var transform = canvas.transform
		transform.origin = Vector2(20, 125)
		canvas.transform = transform
		paused = true
		$VBoxContainer/Pause.text = "Unpause"
	else:
		paused = false
		var transform = canvas.transform
		transform.origin = Vector2(20, 70)
		canvas.transform = transform
		$VBoxContainer/Pause.text = "Pause"
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
