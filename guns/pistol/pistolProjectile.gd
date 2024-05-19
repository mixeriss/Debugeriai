extends Area2D

var travelledDistance = 0
var bulletDamage = 0

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 2000
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelledDistance += SPEED * delta
	if travelledDistance > RANGE:
		queue_free()

func setDamage(dmg):
	bulletDamage = dmg

func _on_body_entered(body):
	queue_free()
	if body.has_method("takeDamage"):
		body.takeDamage(bulletDamage)
