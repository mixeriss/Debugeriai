extends CharacterBody2D

@export var NORMAL_SPEED = 150.0
@export var SPRINT_SPEED = 200.0
@export var CROUCH_SPEED = 110.0
@export var PRONE_SPEED = 80.0

@onready var pistol = %Pistol

var currentSpeed = NORMAL_SPEED

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
	if event.is_action_pressed("zoom in") && $Camera2D.zoom < Vector2(4, 4):
		$Camera2D.zoom = Vector2($Camera2D.zoom.x+0.25, $Camera2D.zoom.y+0.25)
	if event.is_action_pressed("zoom out") && $Camera2D.zoom > Vector2(2, 2):
		$Camera2D.zoom = Vector2($Camera2D.zoom.x-0.25, $Camera2D.zoom.y-0.25)
	pass

func config_player_camera(pixels):
	$Camera2D.limit_top = 0
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = pixels.x
	$Camera2D.limit_bottom = pixels.y
	pass

func set_pos(pixelCoords):
	position = pixelCoords
	pass

func _on_water_detection_body_entered(body):
	NORMAL_SPEED /= 3
	SPRINT_SPEED /= 3
	CROUCH_SPEED = NORMAL_SPEED
	PRONE_SPEED = NORMAL_SPEED
	$Sprite2D.modulate = Color(0.39, 0.61, 1, 0.7)
	pass

func _on_water_detection_body_exited(body):
	NORMAL_SPEED *= 3
	SPRINT_SPEED *= 3
	CROUCH_SPEED = 110.0
	PRONE_SPEED = 80.0
	$Sprite2D.modulate = Color(1, 1, 1, 1)
	pass
