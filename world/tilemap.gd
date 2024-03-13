extends TileMap

func generate_map(size):
	generate_land(size)
	generate_resources(size)
	pass

func generate_land(size):
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	noise.frequency = 0.025
	noise.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	noise.fractal_octaves = 4
	noise.fractal_lacunarity = 2
	noise.fractal_gain = 0.65
	noise.fractal_weighted_strength = 0.35
	noise.fractal_ping_pong_strength = 2
	noise.seed = randi()
	for x in size.x:
		for y in size.y:
			var random = noise.get_noise_2d(x, y)+1
			set_cell(0, Vector2(x, y), random, Vector2(0, 0), 0)
	pass
	
func generate_resources(size):
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.115
	noise.seed = randi()
	for x in size.x:
		for y in size.y:
			var random = abs(noise.get_noise_2d(x, y))
			if random > 0.5 && get_cell_source_id(0, Vector2(x, y)) == 0:
				set_cell(0, Vector2(x, y), 2, Vector2(0, 0), 0)
	noise.frequency = 0.15
	noise.seed = randi()
	for x in size.x:
		for y in size.y:
			var random = abs(noise.get_noise_2d(x, y))
			if random > 0.65 && get_cell_source_id(0, Vector2(x, y)) == 0:
				set_cell(0, Vector2(x, y), 3, Vector2(0, 0), 0)
	pass
	
	pass

func tile_has_collision(coords):
	return (get_cell_tile_data(0, coords).get_collision_polygons_count(0)) > 0
