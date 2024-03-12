extends Node2D

var map

func _ready():
	load_world()
	load_player()
	pass

func load_world():
	map = preload("res://world/world.tscn").instantiate()
	add_child(map)
	pass

func load_player():
	var player = preload("res://player/player.tscn").instantiate()
	add_child(player)
	player.config_player_camera(map.pxSize)
	var coords = map.find_spawn_point()
	player.set_pos(coords.x, coords.y)
	pass
