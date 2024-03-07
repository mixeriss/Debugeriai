extends Node2D


@onready var tilemap = $TileMap
@onready var player = $Player
@onready var player_camera = $Player/Camera2D
@onready var top_border = $Borders/TopBorder
@onready var left_border = $Borders/LeftBorder
@onready var bottom_border = $Borders/BottomBorder
@onready var right_border = $Borders/RightBorder
const size = Vector2(50, 50)
const px = 34
const size_px = Vector2(size.x*px, size.y*px)


func _ready():
	tilemap.clear()
	generate_map()
	set_player()
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
	
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(0, Vector2(x, y), 1, Vector2(0, 0), 0)
	pass


func set_player():
	player_camera.limit_top = 0
	player_camera.limit_left = 0
	player_camera.limit_bottom = size_px.y
	player_camera.limit_right = size_px.x
	
	var r = RandomNumberGenerator.new()
	var x = r.randi_range(0, size_px.x)
	var y = r.randi_range(0, size_px.y)
	player.position = Vector2(x, y)
	pass

