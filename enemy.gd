extends CharacterBody2D

@export var SPEED = 150.0
@export var HEALTH = 50.0

@onready var sprite_2d = %AnimatedSprite2D
@onready var progress_bar = %ProgressBar
@onready var player = get_node("/root/Game/Player")
@onready var punchSound = $DamageSound
@onready var deathSound = $DeathSound

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
	punchSound.play()
	if HEALTH <= 0:
		SPEED = 0.0
		deathSound.play()
		await get_tree().create_timer(0.2).timeout
		var gun = preload("res://gun_pickup.tscn")
		var newGun = gun.instantiate()
		newGun.global_position = global_position
		get_parent().add_child(newGun)
		newGun.generate()
		player.currentScore += 10
		queue_free()

func _on_water_detection_body_entered(body):
	SPEED /= 3
	sprite_2d.modulate = Color(0.39, 0.61, 1, 0.7)
	pass

func _on_water_detection_body_exited(body):
	SPEED *= 3
	sprite_2d.modulate = Color(1, 1, 1, 1)
	pass
