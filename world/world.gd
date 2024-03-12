extends Node2D

@export var size = Vector2(250, 250)

@onready var tilemap = $TileMap
@onready var borders = $Borders
@onready var pxSize = Vector2(tilemap.tile_set.tile_size.x*size.x, tilemap.tile_set.tile_size.y*size.y)

func _ready():
	randomize()
	tilemap.generate_map(size)
	borders.set_borders(pxSize)
	pass

func find_spawn_point():
	var pxX = randi_range(tilemap.tile_set.tile_size.x, pxSize.x-tilemap.tile_set.tile_size.x)
	var pxY = randi_range(tilemap.tile_set.tile_size.y, pxSize.y-tilemap.tile_set.tile_size.y)
	var x = pxX/tilemap.tile_set.tile_size.x
	var y = pxY/tilemap.tile_set.tile_size.y
	if tilemap.tile_has_collision(x, y):
		tilemap.clear_cell(x, y)
	if tilemap.tile_has_collision(x+1, y):
		tilemap.clear_cell(x+1, y)
	if tilemap.tile_has_collision(x, y+1):
		tilemap.clear_cell(x, y+1)
	if tilemap.tile_has_collision(x+1, y+1):
		tilemap.clear_cell(x+1, y+1)
	return Vector2(pxX, pxY)
