extends Area2D

@onready var color_rect = %ColorRect

func slice():
	look_at(get_global_mouse_position())
	color_rect.visible = true
	var slashiedEnemies = get_overlapping_bodies()
	for enemy in slashiedEnemies:
		if enemy.has_method("takeDamage"):
			enemy.takeDamage(15)
	await get_tree().create_timer(0.1).timeout
	color_rect.visible = false
