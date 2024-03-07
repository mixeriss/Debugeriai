extends Node2D

@onready var tilemap = $TileMap
@onready var character_body = $CharacterBody2D
const size = Vector2(100, 100)
var r = RandomNumberGenerator.new()

func _ready():
	tilemap.clear()
	generate_map()

func generate_map():	
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(0, Vector2(x, y), 1, Vector2(0, 0), 0)
	pass

func set_spawn_point():
	var x = r.randi_range(0, size.x-1)
	var y = r.randi_range(0, size.y-1)

	pass
