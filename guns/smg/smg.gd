extends Node2D

@onready var firerate = %firerate
@onready var shoot_sound = %ShootSound
@onready var pivot = %pivot
@onready var sprite_2d = %Sprite2D
@onready var shooting_point = %shootingPoint
@onready var audio_stream_player_2d = %AudioStreamPlayer2D

var mag_size = 26
var ammo_count = 26

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	if(get_global_mouse_position().x < get_parent().global_position.x):
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
		
func shoot():
		if firerate.is_stopped():
			if ammo_count <= 0:
				return
			firerate.start()
			ammo_count -= 1
			const PROJECTILE = preload("res://guns/pistol/pistolProjectile.tscn")
			var newProjectile = PROJECTILE.instantiate()
			newProjectile.global_position = shooting_point.global_position
			newProjectile.global_rotation = shooting_point.global_rotation
			shooting_point.add_child(newProjectile)
			newProjectile.setDamage(8)
			audio_stream_player_2d.play()
			
