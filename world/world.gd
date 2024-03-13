extends Node2D

@onready var _tilemap = $TileMap
@onready var _borders = $Borders

var _size = Vector2(250, 250)

func _ready():
	randomize()
	_tilemap.generate_map(_size)
	_borders.set_borders(get_pixel_size())
	pass

func find_spawn_point():
	var x = randi_range(1, _size.x-2)
	var y = randi_range(1, _size.y-2)
	if _tilemap.tile_has_collision(Vector2(x+1, y+1)):
		return find_spawn_point()
	return Vector2(17+34*x, 17+34*y)

func get_pixel_size():
	return Vector2(_tilemap.tile_set.tile_size.x*_size.x, _tilemap.tile_set.tile_size.y*_size.y)
