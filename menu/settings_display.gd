extends Control

const WINDOW_MODES: Array[String] = [
	"Full-screen",
	"Window mode",
	"Borderless Window",
	"Borderless full-screen"
]
# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()
	$HBoxContainer/OptionButton.item_selected.connect(on_window_mode_selected)
	pass # Replace with function body.
	
func add_items():
	for mode in WINDOW_MODES:
		$HBoxContainer/OptionButton.add_item(mode)
		
func on_window_mode_selected(index : int):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	pass
