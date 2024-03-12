extends Node2D

@onready var shootingpoint = %shootingPoint
@onready var firerate = %firerate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())

func shoot():
	if firerate.is_stopped():
		const PROJECTILE = preload("res://guns/pistol/pistolProjectile.tscn")
		var newProjectile = PROJECTILE.instantiate()
		newProjectile.global_position = shootingpoint.global_position
		newProjectile.global_rotation = shootingpoint.global_rotation
		shootingpoint.add_child(newProjectile)
		firerate.start()
