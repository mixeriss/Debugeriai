extends CharacterBody2D

signal HealthDepleted(points)
signal TileHit(mouse_pos)
signal TileBoom(mouse_pos)
signal TilePlace(mouse_pos, n) 

@export var NORMAL_SPEED = 150.0
@export var SPRINT_MULT = 1.5
@export var CROUCH_MULT = 0.5
@export var DODGE_MULTIPLIER = 2.0
@export var HEALTH = 100
@export var GRENADE_COUNT = 5

@onready var melee = %Melee
@onready var camera_2d = %Camera2D
@onready var sprite_2d = %Sprite2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var dodge_interval = %DodgeInterval
@onready var dodge_cooldown = %DodgeCooldown
@onready var progress_bar = %ProgressBar
@onready var footprint_sprite_2d = %footprintSprite2D
@onready var hurtbox = %Hurtbox
@onready var scoreUI = %Score
@onready var pick_up_finder = %PickUpFinder
@onready var grenade_count_ui = $resource_gui/GrenadeCountUI
@onready var melee_cooldown = $MeleeCooldown

var currentSpeed = NORMAL_SPEED
var blockDetectionMode = true
var dodging = false
var vulnerable = true
var body_on_water = false
var lastDirection
var range = Vector2(68, 68)
var mirr_footprint = false
var direction
var resource_inv = {"wood": 0, "stone": 0, "iron": 0}
var inv = ["pickaxe", "melee", "", ""]
var sel_n = 1
var sel_block_n = 1
var currentScore = 0
var showingScore = 0
var gunName = "none"
var hasGun = false
var newGun

const pistolPre = preload("res://guns/pistol/pistol.tscn")

func _ready():
	grenade_count_ui.text = "Grenades: " + str(GRENADE_COUNT)
	updateScore(0)
	update_inv()
	pass

func _physics_process(delta):
	#checks if there are any pickupable guns near the player and picks up the closest one
	if Input.is_action_just_released("interact"):
		var pickups = pick_up_finder.get_overlapping_areas()
		if pickups.size() > 0:
			var gunName = pickups[0].label.text
			match gunName:
				"grenade":
					GRENADE_COUNT = GRENADE_COUNT + 1;
					grenade_count_ui.text = "Grenades: " + str(GRENADE_COUNT)
				"pistol":
					if hasGun == false:
						inv[2] = "gun"
						$inventory_gui/inventory_control/inv3item.visible = true
						gunName = "pistol"
						hasGun = true
						newGun = pistolPre.instantiate()
						add_child(newGun)
						
			pickups[0].queue_free()
	
	#updates score
	if (currentScore != showingScore):
		updateScore(currentScore)
		showingScore = currentScore
		
	#movement
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
	
	#shoot gun
	if Input.is_action_pressed("primary") and inv[sel_n-1] == "gun":
		newGun.shoot()
	
	#break block
	if Input.is_action_pressed("primary") and inv[sel_n-1] == "pickaxe":
		var mp = get_global_mouse_position()
		if abs(position.x - mp.x) <= range.x and abs(position.y - mp.y) <= range.y:
			TileHit.emit(get_global_mouse_position())
	
	#place block
	if Input.is_action_pressed("place"):
		var mp = get_global_mouse_position()
		if abs(position.x - mp.x) <= range.x and abs(position.y - mp.y) <= range.y:
			if sel_block_n == 1 and resource_inv["wood"] >= 5:
				TilePlace.emit(get_global_mouse_position(), 1)
			if sel_block_n == 2 and resource_inv["stone"] >= 5:
				TilePlace.emit(get_global_mouse_position(), 2)
		pass
	
	#dodge 
	if Input.is_action_just_pressed("dodge") && dodge_cooldown.is_stopped():
		dodgeStart()
	
	#melee attack
	if Input.is_action_just_pressed("melee") && inv[sel_n-1] == "melee":
		melee.slice()
		melee_cooldown.start()
		
	#throw grenade
	if Input.is_action_just_pressed("grenade") && GRENADE_COUNT > 0:
		throw_grenade()
		GRENADE_COUNT -= 1
		grenade_count_ui.text = "Grenades: " + str(GRENADE_COUNT)
	
	#calculates number of enemies on player and deals damage
	var overlappingMobs = hurtbox.get_overlapping_bodies()
	const damageRate = 5.0
	if overlappingMobs.size() > 0:
		HEALTH -= damageRate * overlappingMobs.size() * delta
		progress_bar.value = HEALTH
		if HEALTH <= 0.0:
			HealthDepleted.emit(currentScore)

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
	if event.is_action_pressed("inventory_1"):
		sel_n = 1
		update_inv()
	if event.is_action_pressed("inventory_2"):
		sel_n = 2
		update_inv()
	if event.is_action_pressed("inventory_3"):
		sel_n = 3
		update_inv()
	if event.is_action_pressed("inventory_4"):
		sel_n = 4
		update_inv()
	if event.is_action_pressed("select_wood"):
		sel_block_n = 1
		update_inv()
	if event.is_action_pressed("select_stone"):
		sel_block_n = 2
		update_inv()
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

func _on_dodge_interval_timeout():
	dodging = false
	vulnerable = true
	dodge_cooldown.start()

func takeDamage(damage):
	if vulnerable:
		HEALTH -= damage
		progress_bar.value = HEALTH
		if HEALTH <= 0.0:
			HealthDepleted.emit(currentScore)

func setCameraLimits(pixel_size):
	$Camera2D.limit_right = pixel_size.x
	$Camera2D.limit_bottom = pixel_size.y
	pass

func _on_ftp_timer_timeout():	
	if (!body_on_water && direction !=  Vector2.ZERO && !Input.is_action_pressed("crouch")):
		const footprint = preload("res://footprint.tscn")
		var new_footprint = footprint.instantiate()
		new_footprint.global_position = global_position
		get_parent().add_child(new_footprint)	
		new_footprint.mirror(mirr_footprint)
		mirr_footprint = !mirr_footprint
	pass
	
func update_inv():
	$resource_gui/wood_amount.text = str(resource_inv["wood"])
	$resource_gui/stone_amount.text = str(resource_inv["stone"])
	$resource_gui/iron_amount.text = str(resource_inv["iron"])
	
	$inventory_gui/inventory_control/inv1.visible = true
	$inventory_gui/inventory_control/inv2.visible = true
	$inventory_gui/inventory_control/inv3.visible = true
	$inventory_gui/inventory_control/inv4.visible = true
	$inventory_gui/inventory_control/inv1s.visible = false
	$inventory_gui/inventory_control/inv2s.visible = false
	$inventory_gui/inventory_control/inv3s.visible = false
	$inventory_gui/inventory_control/inv4s.visible = false
	match sel_n:
		1:
			$inventory_gui/inventory_control/inv1.visible = false
			$inventory_gui/inventory_control/inv1s.visible = true
			pass
		2:
			$inventory_gui/inventory_control/inv2.visible = false
			$inventory_gui/inventory_control/inv2s.visible = true
			pass
		3:
			$inventory_gui/inventory_control/inv3.visible = false
			$inventory_gui/inventory_control/inv3s.visible = true
			pass
		4:
			$inventory_gui/inventory_control/inv4.visible = false
			$inventory_gui/inventory_control/inv4s.visible = true
			pass
		_:
			pass
			
	$inventory_gui/inventory_control/inv5.visible = true
	$inventory_gui/inventory_control/inv6.visible = true
	$inventory_gui/inventory_control/inv5s.visible = false
	$inventory_gui/inventory_control/inv6s.visible = false
	match sel_block_n:
		1:
			$inventory_gui/inventory_control/inv5.visible = false
			$inventory_gui/inventory_control/inv5s.visible = true
			pass
		2:
			$inventory_gui/inventory_control/inv6.visible = false
			$inventory_gui/inventory_control/inv6s.visible = true
			pass
		_:
			pass
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

func _on_world__block_breaked(type, amount):
	resource_inv[type] += amount
	update_inv()

func _on_world__block_placed(sig):
	match sig:
		4:
			resource_inv["wood"] -= 5
		5:
			resource_inv["stone"] -= 5
		_:
			pass
	update_inv()

func updateScore(value):
	scoreUI.text = "Score: " + str(value)
