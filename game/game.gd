extends Node2D

func _ready():
	$World.generate_map()
	var coords = $World.find_spawn_point()
	$Player.set_pos(coords)
	var px_size = $World.get_pixel_size()
	$Player.setCameraLimits(px_size)
	$World.connect_player($Player)
	pass
