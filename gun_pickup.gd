extends Area2D

@onready var pistol_sprite = %pistolSprite
@onready var grenade_sprite = $grenadeSprite
@onready var test = %test
var type
var ammoCount

func generate():
	var rng = randi_range(2,2)
	match rng:
		1:
			grenade_sprite.visible = true
			type = "grenade"
		2:
			pistol_sprite.visible = true
			type = "pistol"
			ammoCount = 14

func throw(gunType, pos, ammo):
	type = gunType
	ammoCount = ammo
	match gunType:
		"pistol":
			pistol_sprite.visible = true
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation_degrees", randi_range(180,360), 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
