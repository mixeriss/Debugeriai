extends Node2D

@export var size = Vector2(300, 300)

@onready var tilemap = $TileMap
@onready var borders = $Borders
@onready var pxsize = Vector2(tilemap.tile_set.tile_size.x*size.x, tilemap.tile_set.tile_size.y*size.y)

func _ready():
	randomize()
	tilemap.generate_map(size)
	borders.set_borders(pxsize)
	pass

func create_spawn_point():
	var x_px = randi_range(tilemap.tile_set.tile_size.x, pxsize.x-tilemap.tile_set.tile_size.x)
	var y_px = randi_range(tilemap.tile_set.tile_size.y, pxsize.y-tilemap.tile_set.tile_size.y)
	tilemap.clear_space_around_pixel(x_px, y_px)
	return Vector2(x_px, y_px)
