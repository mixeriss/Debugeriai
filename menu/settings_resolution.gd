extends Control

const RESOLUTION : Dictionary = {
	"1152 x 648" : Vector2(1152, 648),
	"1280 x 720" : Vector2(1280, 720),
	"1920 x 1080" : Vector2(1920, 1080)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/OptionButton.item_selected.connect(on_resolution_selected)
	add_items()
	pass # Replace with function body.
func add_items():
	for resolution in RESOLUTION:
		$HBoxContainer/OptionButton.add_item(resolution)
	
func on_resolution_selected(index: int):
	DisplayServer.window_set_size(RESOLUTION.values()[index])
	pass


