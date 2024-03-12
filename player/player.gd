extends CharacterBody2D # shows what type of object the code belongs to

# constant variables
@export var NORMAL_SPEED = 300.0
@export var SPRINT_SPEED = 450.0
@export var CROUCH_SPEED = 175.0
@export var PRONE_SPEED = 80.0

# access unique objects
@onready var pistol = %Pistol
@onready var camera = $Camera2D

# variables that are to be changed during runtime
var currentSpeed = NORMAL_SPEED # assigns the default speed value

func _physics_process(delta): # code in "_physics_process" is run every frame
	#look_at(get_global_mouse_position())
	# switching movement speed depending on input
	if Input.is_action_pressed("sprint"):
		currentSpeed = SPRINT_SPEED
	else:
		if Input.is_action_pressed("crouch"):
			currentSpeed = CROUCH_SPEED
		else:
			if Input.is_action_pressed("prone"):
				currentSpeed = PRONE_SPEED
			else:
				currentSpeed = NORMAL_SPEED
	
	# getting the direction of movement and , must have set input controls in project >> project
	# settings >> input map beforehand
	var direction = Input.get_vector("left", "right", "up", "down") 
	velocity = direction * currentSpeed
	
	if Input.is_action_pressed("shoot gun"):
		pistol.shoot()
	
	move_and_slide() # in-built method for detecting collisions and making the object slide around
	# the collisioned object

func _input(event):
	if event.is_action_pressed("zoom in"):
		if camera.zoom < Vector2(5, 5):
			camera.zoom = Vector2(camera.zoom.x+0.25, camera.zoom.y+0.25)
	elif event.is_action_pressed("zoom out"):
		if camera.zoom > Vector2(2.5, 2.5):
			camera.zoom = Vector2(camera.zoom.x-0.25, camera.zoom.y-0.25)
	pass

func config_player_camera(pxSize):
	camera.limit_top = 0
	camera.limit_left = 0
	camera.limit_bottom = pxSize.y
	camera.limit_right = pxSize.x
	pass

func set_pos(x, y):
	position = Vector2(x, y)
	pass
