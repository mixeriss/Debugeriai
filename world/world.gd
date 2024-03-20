extends Node2D

@onready var _tilemap = $TileMap
@onready var _borders = $Borders

var _size = Vector2(25, 25)

func generate_map():
	randomize()
	_tilemap.generate_map(_size)
	_borders.set_borders(get_pixelSize())

func get_data_array():
	return _tilemap.get_data_array(_size)

func load_map_from_data_array(data_array):
	_tilemap.load_data_from_array(_size, data_array)
	pass

func find_spawn_point():
	var coords = Vector2(randi_range(0, _size.x-1), randi_range(0, _size.y-1))
	if _tilemap.tile_is_land(coords):
		return to_pixelCoords(coords)
	return find_spawn_point()

func get_pixelSize():
	return Vector2(_tilemap.tile_set.tile_size.x*_size.x, _tilemap.tile_set.tile_size.y*_size.y)

func to_pixelCoords(coords: Vector2):
	return Vector2(_tilemap.tile_set.tile_size.x/2+_tilemap.tile_set.tile_size.x*coords.x, _tilemap.tile_set.tile_size.y/2+_tilemap.tile_set.tile_size.y*coords.y)
