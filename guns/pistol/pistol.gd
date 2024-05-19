extends Area2D

@onready var shootingpoint = %shootingPoint
@onready var firerate = %firerate
@onready var sprite_2d = $weaponPivot/Sprite2D
var is_shooting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	if(get_global_mouse_position().x < get_parent().global_position.x):
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false
func shoot():
		if firerate.is_stopped():
			const PROJECTILE = preload("res://guns/pistol/pistolProjectile.tscn")
			var newProjectile = PROJECTILE.instantiate()
			newProjectile.global_position = shootingpoint.global_position
			newProjectile.global_rotation = shootingpoint.global_rotation
			shootingpoint.add_child(newProjectile)
			firerate.start()
