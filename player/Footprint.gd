extends Node2D
@onready var footprint_sprite_2d = %footprintSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5).timeout
	queue_free()
	pass # Replace with function body.

func mirror(wasLastMirrored):
	footprint_sprite_2d.flip_h  = wasLastMirrored 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
