extends Area2D

@onready var shootingpoint = %shootingPoint
@onready var firerate = %firerate
@onready var color_rect = %ColorRect
@onready var sprite_2d = $weaponPivot/Sprite2D


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

func slice():
	color_rect.visible = true
	var slashiedEnemies = get_overlapping_bodies()
	for enemy in slashiedEnemies:
		if enemy.has_method("takeDamage"):
			enemy.takeDamage(2)
	await get_tree().create_timer(0.1).timeout
	color_rect.visible = false
