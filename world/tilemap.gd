extends TileMap

func generate_map(size):
	var noise = FastNoiseLite.new()
	noise.frequency = 0.175
	noise.seed = randi()
	for x in size.x:
		for y in size.y:
			var random = abs(noise.get_noise_2d(x, y))
			set_cell(0, Vector2(x, y), 0, Vector2(0, 0), 0)
	pass

func tile_has_collision(x, y):
	return get_cell_tile_data(0, Vector2(x, y)).get_collision_polygons_count(0) > 0

func clear_cell(x, y):
	var cell_alt = get_cell_alternative_tile(0, Vector2(x, y))
	set_cell(0, Vector2(x, y), 0, Vector2(0, 0), cell_alt)
	pass
