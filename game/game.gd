extends Node2D

@onready var path_follow_2d = %PathFollow2D
@onready var game_over = %GameOver

func _ready():
	$World.generate_map()
	var coords = $World.find_spawn_point()
	$Player.set_pos(coords)
	var px_size = $World.get_pixel_size()
	$Player.setCameraLimits(px_size)
	pass

func spawn_mob():
	var ENEMY = preload("res://enemy.tscn").instantiate()
	path_follow_2d.progress_ratio = randf()
	ENEMY.global_position = path_follow_2d.global_position
	add_child(ENEMY)

func _on_mob_spawn_timer_timeout():
	spawn_mob()

func _on_player_health_depleted():
	#get_tree().paused = true
	game_over.visible = true;
	#await get_tree().create_timer(5).timeout
	#get_tree().change_scene_to_file("res://menu/menu.tscn")
