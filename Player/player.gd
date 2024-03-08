extends CharacterBody2D # shows what type of object the code belongs to

# constant variables
@export var NORMAL_SPEED = 300.0
@export var SPRINT_SPEED = 450.0
@export var CROUCH_SPEED = 175.0
@export var PRONE_SPEED = 80.0

# variables that are to be changed during runtime
var currentSpeed = NORMAL_SPEED # assigns the default speed value

func _physics_process(delta): # code in "_physics_process" is run every frame
	
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

	move_and_slide() # in-built method for detecting collisions and making the object slide around
	# the collisioned object


func config_player_camera(size_px):
	var c = $Camera2D
	c.limit_top = 0
	c.limit_left = 0
	c.limit_bottom = size_px.y
	c.limit_right = size_px.x
	pass

