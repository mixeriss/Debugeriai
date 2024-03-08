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
	var r = RandomNumberGenerator.new()
	var x = r.randi_range(0, w.size_px.x)
	var y = r.randi_range(0, w.size_px.y)
	pl.position = Vector2(x, y)
	add_child(pl)
	pass

