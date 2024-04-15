extends CharacterBody2D

signal HealthDepleted

@export var NORMAL_SPEED = 150.0
@export var SPRINT_MULT = 1.5
@export var CROUCH_MULT = 0.5
@export var DODGE_MULTIPLIER = 2.0
@export var HEALTH = 100

@onready var pistol = %Pistol
@onready var camera_2d = %Camera2D
@onready var sprite_2d = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var dodge_interval = %DodgeInterval
@onready var dodge_cooldown = %DodgeCooldown
@onready var progress_bar = %ProgressBar

var alive = true
var currentSpeed = NORMAL_SPEED
var blockDetectionMode = false
var dodging = false
var vulnerable = true
var lastDirection

func _enter_tree():
	var size = World.new()
	$Camera2D.limit_right = (size.mapSize * 34) + 220
	$Camera2D.limit_bottom = (size.mapSize * 34) + 140
	set_multiplayer_authority(name.to_int())
	$Camera2D.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if is_multiplayer_authority():
		var direction = Input.get_vector("left", "right", "up", "down") 
		if(dodging == false):
			currentSpeed = NORMAL_SPEED
			if Input.is_action_pressed("sprint"):
				currentSpeed = NORMAL_SPEED * SPRINT_MULT
			elif Input.is_action_pressed("crouch"):
				currentSpeed = NORMAL_SPEED * CROUCH_MULT
			velocity = direction * currentSpeed
			lastDirection = direction
		else:
			velocity = lastDirection * currentSpeed
		move_and_slide()
		if Input.is_action_pressed("primary") && blockDetectionMode == false && alive:
			pistol.shoot()
		if Input.is_action_pressed("primary") and blockDetectionMode && alive:
			var xc = get_global_mouse_position().x - 220
			var yc = get_global_mouse_position().y - 140
			var realposx = position.x + 218+17
			var realposy = position.y + 76+17
			if abs(xc - realposx) <= 68.0 and abs(yc - realposy) <= 68.0:
				var w = get_parent().get_child(2)
				w.break_tile(Vector2(floor((get_global_mouse_position().x-220)/34), floor((get_global_mouse_position().y-140)/34)))
		if Input.is_action_just_pressed("block detection mode") && alive:
			blockDetectionMode = !blockDetectionMode
			pistol.visible = !blockDetectionMode
		if Input.is_action_just_pressed("dodge") && dodge_cooldown.is_stopped() && alive:
			dodging = true;
			vulnerable = false
			currentSpeed = NORMAL_SPEED * DODGE_MULTIPLIER
			dodge_interval.start()
	pass

func _input(event):
	if event.is_action_pressed("zoom in"):
		if camera_2d.zoom < Vector2(4, 4):
			camera_2d.zoom = Vector2(camera_2d.zoom.x + 0.5, camera_2d.zoom.y + 0.5)
	if event.is_action_pressed("zoom out"):
		if camera_2d.zoom > Vector2(2, 2):
			camera_2d.zoom = Vector2(camera_2d.zoom.x - 0.5, camera_2d.zoom.y - 0.5)
	pass

func set_pos(pixelCoords):
	position = pixelCoords
	pass

func _on_water_detection_body_entered(body):
	NORMAL_SPEED /= 3
	sprite_2d.modulate = Color(0.39, 0.61, 1, 0.7)
	pass

func _on_water_detection_body_exited(body):
	NORMAL_SPEED *= 3
	sprite_2d.modulate = Color(1, 1, 1, 1)
	pass

func _on_block_detection_timer_timeout():
	if blockDetectionMode == true:
		var facingTile = get_parent().get_child(2).get_child(0).FindFacingTile(collision_shape_2d.global_position)
	pass

func _on_dodge_interval_timeout():
	dodging = false
	vulnerable = true
	dodge_cooldown.start()

func takeDamage(damage):
	HEALTH -= damage
	progress_bar.value = HEALTH
	if HEALTH <= 0.0:
		HealthDepleted.emit()
		NORMAL_SPEED = 0
		alive = false
