extends Node2D

@onready var tilemap = $TileMap
const size = Vector2(20, 20)

func _ready():
	tilemap.clear()
	generate_map()

func generate_map():	
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(0, Vector2(x, y), 1, Vector2(0, 0), 0)
	pass
