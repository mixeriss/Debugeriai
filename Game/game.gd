extends Node2D


func _ready():
	load_world()
	load_player()
	pass


var w
func load_world():
	w = preload("res://World/world.tscn").instantiate()
	add_child(w)
	pass


func load_player():
	var pl = preload("res://Player/player.tscn").instantiate()
	pl.config_player_camera(w.size_px)
	var spawn_point = w.find_spawn_point()
	pl.position = spawn_point
	add_child(pl)
	pass

