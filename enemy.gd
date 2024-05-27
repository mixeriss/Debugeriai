extends CharacterBody2D

@export var SPEED = 150.0
@export var HEALTH = 50.0
@export var score_g = 10

@onready var sprite_2d = %AnimatedSprite2D
@onready var progress_bar = %ProgressBar
@onready var player = get_node("/root/Game/Player")
@onready var punchSound = $DamageSound
@onready var deathSound = $DeathSound
signal on_death()

func change_multiplier(wave):
	SPEED = SPEED * log(wave+1)
	HEALTH = HEALTH * log(wave+1)

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
		on_death.emit()
		SPEED = 0.0
		deathSound.play()
		await get_tree().create_timer(0.2).timeout
		var gun = preload("res://gun_pickup.tscn")
		var newGun = gun.instantiate()
		newGun.global_position = global_position
		get_parent().add_child(newGun)
		newGun.generate()
		player.currentScore += score_g
		queue_free()

func _on_water_detection_body_entered(body):
	SPEED /= 3
	sprite_2d.modulate = Color(0.39, 0.61, 1, 0.7)
	pass

func _on_water_detection_body_exited(body):
	SPEED *= 3
	sprite_2d.modulate = Color(1, 1, 1, 1)
	pass

func make_harder_enemy():
	SPEED = 25
	HEALTH = 10000
	score_g = 100
	$AnimatedSprite2D.scale.x = 1.25
	$AnimatedSprite2D.scale.y = 1.25
	pass
