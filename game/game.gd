extends Node2D

var worldmap

func _ready():
	load_world()
	load_player()
	pass

func load_world():
	worldmap = preload("res://world/world.tscn").instantiate()
	add_child(worldmap)
	pass

func load_player():
	var player = preload("res://player/player.tscn").instantiate()
	add_child(player)
	player.config_player_camera(worldmap.pxsize)
	var spawnpoint = worldmap.create_spawn_point()
	player.set_pos(spawnpoint)
	pass
