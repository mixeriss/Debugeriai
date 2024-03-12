extends Node2D

@export var size = Vector2(100, 100)

@onready var tilemap = $TileMap
@onready var borders = $Borders
@onready var pxsize = Vector2(tilemap.tile_set.tile_size.x*size.x, tilemap.tile_set.tile_size.y*size.y)

func _ready():
	randomize()
	tilemap.generate_map(size)
	borders.set_borders(pxsize)
	pass

func find_spawn_point():
	var x_px = randi_range(tilemap.tile_set.tile_size.x, pxsize.x-tilemap.tile_set.tile_size.x)
	var y_px = randi_range(tilemap.tile_set.tile_size.y, pxsize.y-tilemap.tile_set.tile_size.y)
	var x = x_px/tilemap.tile_set.tile_size.x
	var y = y_px/tilemap.tile_set.tile_size.y
	if tilemap.tile_has_collision(x, y):
		tilemap.clear_cell(x, y)
	if tilemap.tile_has_collision(x+1, y):
		tilemap.clear_cell(x+1, y)
	if tilemap.tile_has_collision(x, y+1):
		tilemap.clear_cell(x, y+1)
	if tilemap.tile_has_collision(x+1, y+1):
		tilemap.clear_cell(x+1, y+1)
	return Vector2(x_px, y_px)
