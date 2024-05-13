extends Area2D

@onready var label = %Label
@onready var pistol_sprite = %pistolSprite
@onready var grenade_sprite = $grenadeSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = randi_range(1,3)
	match rng:
		1:
			grenade_sprite.visible = true
			label.text = "grenade"
		2:
			pistol_sprite.visible = true
			label.text = "pistol"
