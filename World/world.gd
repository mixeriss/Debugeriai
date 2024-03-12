extends Node2D


@onready var tilemap = $TileMap
@onready var top_border = $Borders/TopBorder
@onready var left_border = $Borders/LeftBorder
@onready var bottom_border = $Borders/BottomBorder
@onready var right_border = $Borders/RightBorder
const size = Vector2(100, 100)
const px = 34
const size_px = Vector2(size.x*px, size.y*px)


func _ready():
	tilemap.clear()
	generate_map()
	pass


func generate_map():
	top_border.position = Vector2(size_px.x/2, -1)
	top_border.scale = Vector2(size_px.x/2, 1)
	left_border.position = Vector2(-1, size_px.y/2)
	left_border.scale = Vector2(1, size_px.y/2)
	bottom_border.position = Vector2(size_px.x/2, size_px.y+1)
	bottom_border.scale = Vector2(size_px.x/2, 1)
	right_border.position = Vector2(size_px.x+1, size_px.y/2)
	right_border.scale = Vector2(1, size_px.y/2)
	
	var noise = FastNoiseLite.new()
	noise.setup_local_to_scene()
	noise.frequency = 0.25
	randomize()
	noise.seed = randi()
	
	for x in size.x:
		for y in size.y:
			var random = abs(noise.get_noise_2d(x, y))
			if abs(random) >= 0.51:
				tilemap.set_cell(0, Vector2(x, y), 2, Vector2(0, 0), 0)
			elif abs(random) >= 0.45:
				tilemap.set_cell(0, Vector2(x, y), 1, Vector2(0, 0), 0)
			else:
				tilemap.set_cell(0, Vector2(x, y), 0, Vector2(0, 0), 0)

	pass


func find_spawn_point():
	var r = RandomNumberGenerator.new()
	var x = r.randi_range(px*2, size_px.x-px*2)
	var y = r.randi_range(px*2, size_px.y-px*2)
	return Vector2(x, y)

