extends Area2D

@onready var label = %Label
@onready var pistol_sprite = %pistolSprite
@onready var grenade_sprite = $grenadeSprite
@onready var test = %test

func generate():
	var rng = randi_range(0,0)
	match rng:
		1:
			grenade_sprite.visible = true
			label.text = "grenade"
		2:
			pistol_sprite.visible = true
			label.text = "pistol"

func throw(gunType, pos):
	label.text = "pistol"
	match gunType:
		"pistol":
			pistol_sprite.visible = true
			#should fix when more guns are implemented, currently method doesnt reach this place if gun is picked up from the ground
	pistol_sprite.visible = true
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation_degrees", randi_range(180,360), 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
