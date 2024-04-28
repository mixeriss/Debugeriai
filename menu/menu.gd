extends Control
func _ready():
	handle_connecting_signals()
	pass

func on_start_button_pressed():
	get_tree().change_scene_to_file("res://Game/Game.tscn")
	pass

func on_options_button_pressed():
	$MarginContainer.visible = false
	$OptionsMenu.set_process(true)
	$OptionsMenu.visible = true
	$TextureRect2.visible = false
	pass

func on_quit_button_pressed():
	get_tree().quit()
	pass

func on_exit_options_menu()-> void:
	$MarginContainer.visible = true
	$OptionsMenu.visible = false
	$TextureRect2.visible = true
	pass

func handle_connecting_signals() -> void:
	$MarginContainer/VBoxContainer/StartButton.button_down.connect(on_start_button_pressed)
	$MarginContainer/VBoxContainer/OptionsButton.button_down.connect(on_options_button_pressed)
	$MarginContainer/VBoxContainer/QuitButton.button_down.connect(on_quit_button_pressed)
	$OptionsMenu.exit_options_menu.connect(on_exit_options_menu)
