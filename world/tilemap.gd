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
			set_cell(0, Vector2(x, y), noise.get_noise_2d(x, y)+1, Vector2(0, 0), 0)
	pass
	
func generate_resources(size):
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.115
	noise.seed = randi()
	for x in size.x:
		for y in size.y:
			if abs(noise.get_noise_2d(x, y)) > 0.5 and tile_is_spawnable(Vector2(x, y)):
				set_cell(0, Vector2(x, y), 2, Vector2(0, 0), 0)
	noise.frequency = 0.15
	noise.offset = Vector3(size.x, size.y, 0)
	for x in size.x:
		for y in size.y:
			if abs(noise.get_noise_2d(x, y)) > 0.65 and tile_is_spawnable(Vector2(x, y)):
				set_cell(0, Vector2(x, y), 3, Vector2(0, 0), 0)
	pass

func tile_is_spawnable(coords):
	return get_cell_tile_data(0, coords).get_custom_data("spawnable")

func tile_is_breakable(coords):
	return get_cell_tile_data(0, coords).get_custom_data("breakable")

func break_tile(coords):
	var type = get_cell_source_id(0, coords)
	set_cell(0, coords, 0, Vector2(0, 0), 0)
	return type

func get_data_array(size: Vector2):
	var data = []
	data.resize(size.x)
	for x in size.x:
		data[x] = []
		data[x].resize(size.y)
		for y in size.y:
			data[x][y] = get_cell_source_id(0, Vector2(x, y))
	return data

func load_data_from_array(size, data):
	for x in size.x:
		for y in size.y:
			set_cell(0, Vector2(x, y), data[x][y], Vector2(0, 0), 0)
	pass

func FindFacingTile(mousePos):
	return map_to_local(local_to_map(mousePos))
	pass

func setCell(coords, id):
	set_cell(0, coords, id, Vector2(0, 0), 0)
	pass
