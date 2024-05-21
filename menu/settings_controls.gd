extends Control

@export var action_name: String = "left"
@onready var label = $HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	pass # Replace with function body.

func set_action_name() -> void:
	label.text = "NONE"
	
	match action_name:
		"up":
			label.text = "Move up"
		"down":
			label.text = "Move down"
		"left":
			label.text = "Move left"
		"right":
			label.text = "Move right"
		"crouch":
			label.text = "Crouch"
		"sprint":
			label.text = "Sprint"
		"primary":
			label.text = "Shoot/Break/Melee"
		"zoom in":
			label.text = "Zoom in"
		"zoom out":
			label.text = "Zoom out"
		"dodge":
			label.text = "Dodge"
		"place":
			label.text = "Place block"
		"grenade":
			label.text = "Throw grenade"
		"inventory_1":
			label.text = "Slot 1"
		"inventory_2":
			label.text = "Slot 2"
		"inventory_3":
			label.text = "Slot 3"
		"inventory_4":
			label.text = "Slot 4"
		"select_wood":
			label.text = "Select wood"
		"select_stone":
			label.text = "Select stone"
		"interact":
			label.text = "Pick up items"
		"throw":
			label.text = "Throw gun"
		"reload":
			label.text = "Reload gun"
		
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	
	if action_event is InputEventMouseButton:
		var button_index = action_event.button_index
		var button_name = " "
		
		match button_index:
			MOUSE_BUTTON_LEFT:
				button_name = "Mouse 1"
			MOUSE_BUTTON_WHEEL_UP:
				button_name = "Mouse Wheel Scroll Up"
			MOUSE_BUTTON_WHEEL_DOWN:
				button_name = "Mouse Wheel Scroll Down"
			MOUSE_BUTTON_RIGHT:
				button_name = "Mouse 2"
		
		$HBoxContainer/Button.text = "%s" % button_name
	else:
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		$HBoxContainer/Button.text = "%s" % action_keycode
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
