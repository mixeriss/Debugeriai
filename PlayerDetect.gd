extends Area2D

signal PlayerFound(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var PlayersInRange = get_overlapping_bodies()
	if PlayersInRange.size() > 0:
		var target = PlayersInRange[0]
		PlayerFound.emit(target)
		queue_free()
