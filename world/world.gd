extends Node2D
class_name World

@onready var _tilemap = $TileMap
@onready var _borders = $Borders
var size = Vector2(100, 100)
signal _block_breaked(type, amount)
signal _block_placed(sig)

func generate_map():
	randomize()
	_tilemap.generate_map(size)
	_borders.set_borders(get_pixel_size())

func find_spawn_point():
	var coords = Vector2(randi_range(0, size.x-1), randi_range(0, size.y-1))
	if _tilemap.tile_is_spawnable(coords):
		return to_pixelCoords(coords)
	return find_spawn_point()

func get_pixel_size():
	return Vector2(_tilemap.tile_set.tile_size.x*size.x, _tilemap.tile_set.tile_size.y*size.y)

func to_pixelCoords(coords: Vector2):
	return Vector2(_tilemap.tile_set.tile_size.x/2+_tilemap.tile_set.tile_size.x*coords.x, _tilemap.tile_set.tile_size.y/2+_tilemap.tile_set.tile_size.y*coords.y)

func _on_player_tile_boom(mouse_pos):
	var hit_coords = Vector2(floor(mouse_pos.x/_tilemap.tile_set.tile_size.x), floor(mouse_pos.y/_tilemap.tile_set.tile_size.y))
	var hits = [hit_coords+Vector2(-1,-1), hit_coords+Vector2(-1,0), hit_coords+Vector2(-1,1), hit_coords+Vector2(0,-1), hit_coords+Vector2(0,0), hit_coords+Vector2(0,1), hit_coords+Vector2(1,-1), hit_coords+Vector2(1,0), hit_coords+Vector2(1,1), ]
	for x in hits:
		if _tilemap.tile_is_breakable(x):
			var type = _tilemap.break_tile(x)
	pass

func _on_player_tile_hit(mouse_pos):
	var hit_coords = Vector2(floor(mouse_pos.x/_tilemap.tile_set.tile_size.x), floor(mouse_pos.y/_tilemap.tile_set.tile_size.y))
	if _tilemap.tile_is_breakable(hit_coords):
		var type = _tilemap.break_tile(hit_coords)
		match type:
			2:
				$BreakWood.play()
				_block_breaked.emit("wood", 5)
				pass
			3:
				$BreakRock.play()
				_block_breaked.emit("stone", 5)
				if randi_range(0, 2) == 2:
					_block_breaked.emit("iron", 1)
				pass
			6:
				_block_breaked.emit("wood", randi_range(0, 30))
				_block_breaked.emit("stone", randi_range(0, 25))
				_block_breaked.emit("iron", randi_range(0, 5))
				_block_breaked.emit("gun", randi_range(0, 9))
				_block_breaked.emit("grenade", randi_range(0, 2))
				pass
			_:
				pass
	pass

func _on_player_tile_place(mouse_pos, n):
	var place_coords = Vector2(floor(mouse_pos.x/_tilemap.tile_set.tile_size.x), floor(mouse_pos.y/_tilemap.tile_set.tile_size.y))
	if _tilemap.tile_is_spawnable(place_coords):
		match n:
			1:
				_tilemap.setCell(place_coords, 4)
				_block_placed.emit(4)
				pass
			2:
				_tilemap.setCell(place_coords, 5)
				_block_placed.emit(5)
				pass
			_:
				pass
	pass
