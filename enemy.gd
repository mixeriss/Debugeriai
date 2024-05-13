extends CharacterBody2D

@export var SPEED = 150.0
@export var HEALTH = 50.0

@onready var sprite_2d = %AnimatedSprite2D
@onready var progress_bar = %ProgressBar
@onready var player = get_node("/root/Game/Player")

func _ready():
	HEALTH = 50.0

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	if(direction.x < 0):
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	move_and_slide()

func takeDamage(damage):
	HEALTH -= damage
	progress_bar.value = HEALTH
	if HEALTH <= 0.0:
		var gun = preload("res://gun_pickup.tscn")
		var newGun = gun.instantiate()
		newGun.global_position = global_position
		get_parent().add_child(newGun)
		player.currentScore += 10
		queue_free()

