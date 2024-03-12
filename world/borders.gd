extends StaticBody2D

@onready var top_border = $TopBorder
@onready var left_border = $LeftBorder
@onready var bottom_border = $BottomBorder
@onready var right_border = $RightBorder

func set_borders(size_px):
	top_border.position = Vector2(size_px.x/2, -1)
	top_border.scale = Vector2(size_px.x/2, 1)
	left_border.position = Vector2(-1, size_px.y/2)
	left_border.scale = Vector2(1, size_px.y/2)
	bottom_border.position = Vector2(size_px.x/2, size_px.y+1)
	bottom_border.scale = Vector2(size_px.x/2, 1)
	right_border.position = Vector2(size_px.x+1, size_px.y/2)
	right_border.scale = Vector2(1, size_px.y/2)
	pass
