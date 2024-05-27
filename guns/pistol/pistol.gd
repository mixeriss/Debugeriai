extends Node2D

@onready var shootingpoint = %shootingPoint
@onready var firerate = %firerate
@onready var shoot_sound = %ShootSound
@onready var sprite_2d = %Sprite2D

var mag_size = 14
var ammo_count = 14

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
			newProjectile.global_position = shootingpoint.global_position
			newProjectile.global_rotation = shootingpoint.global_rotation
			shootingpoint.add_child(newProjectile)
			newProjectile.setDamage(10)
			shoot_sound.play()
			

#DOESNT WORK IDK
func reloadRotate():
	var tween = create_tween()
	tween.parallel().tween_property(sprite_2d, "rotation_degrees", 360, 1).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.play()
	await get_tree().create_timer(1).timeout
	
