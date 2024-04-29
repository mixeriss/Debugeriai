extends Node2D
class_name World

@onready var _tilemap = $TileMap
@onready var _borders = $Borders
var mapSize = 100
var _size = Vector2(mapSize, mapSize)
signal block_breaked(type, amount)
signal block_placed(sig)

func generate_map():
	randomize()
	_tilemap.generate_map(_size)
	_borders.set_borders(get_pixel_size())

func get_data_array():
	return _tilemap.get_data_array(_size)

func load_map_from_data_array(data_array):
	_borders.set_borders(get_pixel_size())
	_tilemap.load_data_from_array(_size, data_array)
	pass

func find_spawn_point():
	var coords = Vector2(randi_range(0, _size.x-1), randi_range(0, _size.y-1))
	if _tilemap.tile_is_land(coords):
		return to_pixelCoords(coords)
	return find_spawn_point()

func get_pixel_size():
	return Vector2(_tilemap.tile_set.tile_size.x*_size.x, _tilemap.tile_set.tile_size.y*_size.y)

func to_pixelCoords(coords: Vector2):
	return Vector2(_tilemap.tile_set.tile_size.x/2+_tilemap.tile_set.tile_size.x*coords.x, _tilemap.tile_set.tile_size.y/2+_tilemap.tile_set.tile_size.y*coords.y)

func _on_TileHit(mouse_pos):
	var hit_coords = Vector2(floor(mouse_pos.x/_tilemap.tile_set.tile_size.x), floor(mouse_pos.y/_tilemap.tile_set.tile_size.y))
	if _tilemap.tile_is_breakable(hit_coords):
		var type = _tilemap.break_tile(hit_coords)
		match type:
			2:
				block_breaked.emit("wood", 5)
			3:
				block_breaked.emit("stone", 5)
				if randi_range(0, 2) == 2:
					block_breaked.emit("iron", 1)
			_:
				pass
	pass
	
func _on_TilePlace(mouse_pos):
	var place_coords = Vector2(floor(mouse_pos.x/_tilemap.tile_set.tile_size.x), floor(mouse_pos.y/_tilemap.tile_set.tile_size.y))
	if !_tilemap.tile_is_breakable(place_coords):
		_tilemap.setCell(place_coords, 4)
		block_placed.emit(0)
	pass

func connect_player(player):
	player.TileHit.connect(_on_TileHit)
	player.TilePlace.connect(_on_TilePlace)
	player.setCameraLimits(get_pixel_size())
	block_breaked.connect(player._give_resources)
	block_placed.connect(player._block_placed)
	pass
