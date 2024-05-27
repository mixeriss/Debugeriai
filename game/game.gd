extends Node2D

@onready var path_follow_2d = %PathFollow2D
@onready var game_over = %GameOver
@onready var pause_menu = $CanvasLayer/PauseMenu
var paused = false
var wave = 1
var kills_per_wave = 5
var killed = 0

func _process(delta):
	if Input.is_action_just_pressed('pause'):
		pauseMenu()
	pass

func pauseMenu():
	if paused:
		pause_menu.hide()
		#$Player/inventory_gui.visible = true
		#$Player/resource_gui.visible = true
		$CanvasLayer/Blur.visible = false
		$Player/inventory_gui/inventory_control/Blur.visible = false
		$Player/inventory_gui/Blur.visible = false
		$Player.set_physics_process(true)
		$Player/resource_gui/Score/GPUParticles2D.visible = true
		$CanvasLayer2/wave_ind.visible = true
		Engine.time_scale = 1
	else:
		pause_menu.show()
		#$Player/inventory_gui.visible = false
		#$Player/resource_gui.visible = false
		$CanvasLayer/Blur.visible = true
		$Player/inventory_gui/inventory_control/Blur.visible = true
		$Player/inventory_gui/Blur.visible = true
		$Player/resource_gui/Score/GPUParticles2D.visible = false
		$Player.set_physics_process(false)
		$CanvasLayer2/wave_ind.visible = false
		Engine.time_scale = 0
	paused = !paused

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
	ENEMY.change_multiplier(wave)
	ENEMY.on_death.connect(_on_enemy_kill)
	add_child(ENEMY)
	if wave >= 10:
		var c = round(wave/10)
		for i in c:
			ENEMY = preload("res://enemy.tscn").instantiate()
			path_follow_2d.progress_ratio = randf()
			ENEMY.global_position = path_follow_2d.global_position
			ENEMY.make_harder_enemy()
			ENEMY.change_multiplier(wave)
			ENEMY.on_death.connect(_on_enemy_kill)
			add_child(ENEMY)
	pass

func _on_mob_spawn_timer_timeout():
	spawn_mob()

func _on_player_health_depleted(points):
	$Player.visible = false
	$Player.set_physics_process(false)
	await get_tree().create_timer(1.5).timeout
	$Player/overScreen.visible = true
	$Player/overScreen.showScore(points)

func _on_enemy_kill():
	killed = killed + 1
	if killed >= kills_per_wave:
		killed = 0;
		kills_per_wave = kills_per_wave + 5
		wave = wave + 1
		$MobSpawnTimer.wait_time = 3/log(wave+1)
		$CanvasLayer2/wave_ind.text = "Wave " + str(wave)
	pass
