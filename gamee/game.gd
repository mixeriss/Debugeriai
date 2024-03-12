extends Node2D


func _ready():
	load_world()
	load_player()
	pass


var worldmap
func load_world():
	worldmap = preload("res://world/world.tscn").instantiate()
	add_child(worldmap)
	pass


func load_player():
	var player = preload("res://player/player.tscn").instantiate()
	player.config_player_camera(worldmap.size_px)
	var spawnpoint = worldmap.find_spawn_point()
	player.position = spawnpoint
	add_child(player)
	pass

