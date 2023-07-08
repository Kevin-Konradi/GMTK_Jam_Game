extends Camera2D

@export var animation_rel_position: float

var init_pos

func _ready():
	%Player.connect("player_spawned", _start_camera_anim)

func _process(delta):
	if animation_rel_position != 0:
		position = interpolate_vec(init_pos, Vector2.ZERO, animation_rel_position)

func _start_camera_anim():
	position = %Player.position
	init_pos = position

func interpolate_vec(a: Vector2, b: Vector2, t: float):
	return Vector2(
		(a.x * t) + (b.x * (t - 1)),
		(a.y * t) + (b.y * (t - 1)),
	)
