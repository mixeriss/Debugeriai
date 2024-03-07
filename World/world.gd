extends Node2D

@onready var tilemap = $TileMap
@onready var character_body = $CharacterBody2D
const size = Vector2(100, 100)

func _ready():
	tilemap.clear()
	generate_map()
	set_spawn_point()
	pass

func generate_map():	
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(0, Vector2(x, y), 1, Vector2(0, 0), 0)
	pass

func set_spawn_point():
	var r = RandomNumberGenerator.new()
	var x = r.randi_range(0, (size.x-1)*34)
	var y = r.randi_range(0, (size.y-1)*34)
	character_body.position = Vector2(x, y)
	pass
