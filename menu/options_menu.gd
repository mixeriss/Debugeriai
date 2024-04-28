extends Control

signal exit_options_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/Exit.button_down.connect(on_exit_pressed)
	set_process(false)
	pass # Replace with function body.
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
