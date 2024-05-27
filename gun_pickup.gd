extends Area2D

@onready var pistol_sprite = %pistolSprite
@onready var grenade_sprite = $grenadeSprite
@onready var test = %test
@onready var smg_sprite = %smgSprite
@onready var light_ammo_sprite = %lightAmmoSprite
@onready var medium_ammo_sprite = %mediumAmmoSprite
@onready var rifle_sprite = %rifleSprite

var type
var ammoCount

func generate():
	var rng = randi_range(1,7)
	if rng == 5:
		grenade_sprite.visible = true
		type = "grenade"
	else:
		if rng <= 2:
			light_ammo_sprite.visible = true
			type = "lightAmmo"
		else:
			if rng >= 6:
				var uh = "rip"
			else:
				medium_ammo_sprite.visible = true
				type = "mediumAmmo"
	match rng:
		10:
			type = "rifle"
			rifle_sprite.visible = true
			ammoCount = 31
		11:
			pistol_sprite.visible = true
			type = "pistol"
			ammoCount = 14
		12:
			smg_sprite.visible = true
			type = "smg"
			ammoCount = 26

func throw(gunType, pos, ammo, chest):
	type = gunType
	ammoCount = ammo
	match gunType:
		"pistol":
			pistol_sprite.visible = true
		"smg":
			smg_sprite.visible = true
		"rifle":
			rifle_sprite.visible = true
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", randi_range(180,360), 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	if(chest == false):
		tween.parallel().tween_property(self, "position", pos, 1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
