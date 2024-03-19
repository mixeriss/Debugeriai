extends StaticBody2D

@onready var _top_border = $TopBorder
@onready var _left_border = $LeftBorder
@onready var _bottom_border = $BottomBorder
@onready var _right_border = $RightBorder

func set_borders(size_px):
	_top_border.position = Vector2(size_px.x/2, -1)
	_top_border.scale = Vector2(size_px.x/2, 1)
	_left_border.position = Vector2(-1, size_px.y/2)
	_left_border.scale = Vector2(1, size_px.y/2)
	_bottom_border.position = Vector2(size_px.x/2, size_px.y+1)
	_bottom_border.scale = Vector2(size_px.x/2, 1)
	_right_border.position = Vector2(size_px.x+1, size_px.y/2)
	_right_border.scale = Vector2(1, size_px.y/2)
	pass
