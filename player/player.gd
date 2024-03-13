extends CharacterBody2D # shows what type of object the code belongs to

# constant variables
@export var NORMAL_SPEED = 150.0
@export var SPRINT_SPEED = 200.0
@export var CROUCH_SPEED = 110.0
@export var PRONE_SPEED = 80.0

# access unique objects
@onready var pistol = %Pistol
@onready var camera = $Camera2D

# variables that are to be changed during runtime
var currentSpeed = NORMAL_SPEED # assigns the default speed value

func _physics_process(delta):
	currentSpeed = NORMAL_SPEED
	if Input.is_action_pressed("sprint"):
		currentSpeed = SPRINT_SPEED
	elif Input.is_action_pressed("crouch"):
		currentSpeed = CROUCH_SPEED
	elif Input.is_action_pressed("prone"):
		currentSpeed = PRONE_SPEED
	var direction = Input.get_vector("left", "right", "up", "down") 
	velocity = direction * currentSpeed
	move_and_slide()
	
	if Input.is_action_pressed("shoot gun"):
		pistol.shoot()
	
	pass
	

func _input(event):
	if event.is_action_pressed("zoom in") && camera.zoom < Vector2(4, 4):
		camera.zoom = Vector2(camera.zoom.x+0.25, camera.zoom.y+0.25)
	if event.is_action_pressed("zoom out") && camera.zoom > Vector2(2, 2):
		camera.zoom = Vector2(camera.zoom.x-0.25, camera.zoom.y-0.25)
	pass

func config_player_camera(pxSize):
	camera.limit_top = 0
	camera.limit_left = 0
	camera.limit_bottom = pxSize.y
	camera.limit_right = pxSize.x
	pass

func set_pos(pxCoords):
	position = pxCoords
	pass
