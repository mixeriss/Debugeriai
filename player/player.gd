extends CharacterBody2D

signal HealthDepleted
signal TileHit(mouse_pos)
signal TileBoom(mouse_pos)
signal TilePlace(mouse_pos)

@export var NORMAL_SPEED = 150.0
@export var SPRINT_MULT = 1.5
@export var CROUCH_MULT = 0.5
@export var DODGE_MULTIPLIER = 2.0
@export var HEALTH = 100
@export var GRENADE_COUNT = 5

@onready var pistol = %Pistol
@onready var camera_2d = %Camera2D
@onready var sprite_2d = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var dodge_interval = %DodgeInterval
@onready var dodge_cooldown = %DodgeCooldown
@onready var progress_bar = %ProgressBar
@onready var footprint_sprite_2d = %footprintSprite2D

var alive = true
var currentSpeed = NORMAL_SPEED
var blockDetectionMode = false
var dodging = false
var vulnerable = true
var body_on_water = false
var lastDirection
var range = Vector2(68, 68)
var wood_am = 0
var stone_am = 0
var iron_am = 0
var mirr_footprint = false
var direction

func _ready():
	update_inv()
	pass

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	$Camera2D.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if is_multiplayer_authority():
		direction = Input.get_vector("left", "right", "up", "down") 
		if dodging == false:
			if direction == Vector2.ZERO:
				sprite_2d.animation = "default"
			else:
				sprite_2d.animation = "walk"
				if(direction.x < 0):
					sprite_2d.flip_h = true
				else:
					sprite_2d.flip_h = false
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
		if(alive):
			if Input.is_action_pressed("primary") and !blockDetectionMode:
				pistol.shoot()
			if Input.is_action_pressed("primary") and blockDetectionMode:
				var mp = get_global_mouse_position()
				if abs(position.x - mp.x) <= range.x and abs(position.y - mp.y) <= range.y:
					TileHit.emit(get_global_mouse_position())
			if Input.is_action_pressed("place") and blockDetectionMode:
				var mp = get_global_mouse_position()
				if abs(position.x - mp.x) <= range.x and abs(position.y - mp.y) <= range.y:
					if wood_am >= 5:
						TilePlace.emit(get_global_mouse_position())
				pass
			if Input.is_action_just_pressed("block detection mode"):
				blockDetectionMode = !blockDetectionMode
				pistol.visible = !blockDetectionMode
			if Input.is_action_just_pressed("dodge") && dodge_cooldown.is_stopped():
				dodgeStart()
			if Input.is_action_just_pressed("melee"):
				pistol.slice()
			if Input.is_action_just_pressed("grenade") && GRENADE_COUNT > 0:
				throw_grenade()
				GRENADE_COUNT -= 1
			
	pass

func dodgeStart():
	dodging = true;
	vulnerable = false
	currentSpeed = NORMAL_SPEED * DODGE_MULTIPLIER
	dodge_interval.start()

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
	body_on_water = true
	NORMAL_SPEED /= 3
	sprite_2d.modulate = Color(0.39, 0.61, 1, 0.7)
	pass

func _on_water_detection_body_exited(body):
	body_on_water = false
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
		visible = false;
		alive = false
		collision_shape_2d.disabled = true
		sprite_2d.animation = "default"
		

func setCameraLimits(pixel_size):
	$Camera2D.limit_right = pixel_size.x
	$Camera2D.limit_bottom = pixel_size.y
	pass

func _on_ftp_timer_timeout():	
	if (!body_on_water && direction !=  Vector2.ZERO && alive):
		const footprint = preload("res://footprint.tscn")
		var new_footprint = footprint.instantiate()
		new_footprint.global_position = global_position
		get_parent().add_child(new_footprint)	
		new_footprint.mirror(mirr_footprint)
		mirr_footprint = !mirr_footprint
	pass

func _give_resources(type, amount):
	match type:
		"wood":
			wood_am += amount
		"stone":
			stone_am += amount
		"iron":
			iron_am += amount
	update_inv()
	pass
	
func update_inv():
	$Camera2D/resource_gui/wood_text.text = str(wood_am)
	$Camera2D/resource_gui/stone_text.text = str(stone_am)
	$Camera2D/resource_gui/iron_text.text = str(iron_am)
	pass

func _block_placed(sig):
	match sig:
		0:
			wood_am -= 5
		_:
			pass
	update_inv()
	pass

func throw_grenade():
	const grenade = preload("res://grenade.tscn")
	var newGrenade = grenade.instantiate()
	var mouse_pos = get_global_mouse_position()
	newGrenade.global_position = global_position
	get_parent().add_child(newGrenade)
	newGrenade.activate(mouse_pos)
	await get_tree().create_timer(2).timeout
	TileBoom.emit(mouse_pos)
