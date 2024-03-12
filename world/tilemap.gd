extends TileMap

func generate_map(size):
	var noise = FastNoiseLite.new()
	noise.frequency = 0.175
	noise.seed = randi()
	for x in size.x:
		for y in size.y:
			var random = abs(noise.get_noise_2d(x, y))
			if abs(random) > 0.535:
				set_cell(0, Vector2(x, y), 2, Vector2(0, 0), 0)
			elif abs(random) > 0.4:
				set_cell(0, Vector2(x, y), 1, Vector2(0, 0), 0)
			else:
				set_cell(0, Vector2(x, y), 0, Vector2(0, 0), 0)
	pass

func clear_space_around_pixel(x_px, y_px):
	var x = x_px/tile_set.tile_size.x
	var y = y_px/tile_set.tile_size.y
	set_cell(0, Vector2(x, y), 0, Vector2(0, 0), 0)
	set_cell(0, Vector2(x+1, y), 0, Vector2(0, 0), 0)
	set_cell(0, Vector2(x, y+1), 0, Vector2(0, 0), 0)
	set_cell(0, Vector2(x+1, y+1), 0, Vector2(0, 0), 0)
	pass
