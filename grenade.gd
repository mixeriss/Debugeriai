extends Area2D

@onready var sprite_2d = %Sprite2D

func activate(mousePos):
	var tween = create_tween()
	tween.tween_property(self, "position", mousePos, 1.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation_degrees", randi_range(180,360), 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(2).timeout
	var bodies = get_overlapping_bodies()
	for x in bodies:
		if x.has_method("takeDamage"):
			x.takeDamage(40)
	sprite_2d.animation = "explode"
	await get_tree().create_timer(0.3).timeout
	queue_free()
