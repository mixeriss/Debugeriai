extends Node2D

func generate_map():
	$World.generate_map()
	pass

func load_map(data_array):
	$World.load_map_from_data_array(data_array)
	pass

func get_map_data():
	return $World.get_data_array()

func find_spawn_point():
	return $World.find_spawn_point()
