extends Control

@onready var audio_value = $HBoxContainer/AudioValue
@onready var audio_name = $HBoxContainer/AudioName
@onready var h_slider = $HBoxContainer/HSlider

@export_enum("Master", "Music", "Sfx") var bus : String

var busIndex: int = 0
func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_index()
	set_label_name()
	set_slider_value()
	
func set_label_name():
	audio_name.text = str(bus) + " Volume"
	
func set_label_audio():
	audio_value.text = str(h_slider.value*100) + " % "

func get_bus_index():
	busIndex = AudioServer.get_bus_index(bus)
	
func on_value_changed(value):
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value))
	set_label_audio()

func set_slider_value():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(busIndex))
	set_label_audio()
