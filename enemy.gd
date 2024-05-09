extends CharacterBody2D

@export var SPEED = 150.0
@export var HEALTH = 50.0

@onready var progress_bar = %ProgressBar

var foundPlayer = false;
var target = null

func _physics_process(delta):
	if foundPlayer:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * SPEED
	
	move_and_slide()

func _on_player_detect_player_found(player):
	var target = player
	foundPlayer = true

func takeDamage(damage):
	HEALTH -= damage
	progress_bar.value = HEALTH
	if HEALTH <= 0.0:
		queue_free()
