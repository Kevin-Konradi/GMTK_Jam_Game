extends RigidBody2D

@onready var player = %Player
var previous_direction = null
var current_direction = null
var _timer = null
var bias_factor = 0.001

const change_direction_time_seconds = 2.0
const force_luke_skywalker = 100.0
const bias_change_rate = 1.01
const increase_bias_time_seconds = 1
const bias_cap = 0.7

# https://ask.godotengine.org/9065/how-to-call-a-method-only-every-1-second
func _ready():
	$Timer.connect("timeout", _on_Timer_timeout)
	$Timer.set_wait_time(change_direction_time_seconds)
	$Timer.set_one_shot(false) # Make sure it loops
	$Timer.start()
	
	$BiasChangeTimer.connect("timeout", _increase_bias_on_timeout)
	$BiasChangeTimer.set_wait_time(increase_bias_time_seconds)
	$BiasChangeTimer.set_one_shot(false)
	$BiasChangeTimer.start()

	
func choose_random_direction():
	var random_direction = Vector2(randf() * 100, 0).rotated(randf() * 2.0 * PI).normalized()
	return random_direction

func player_bias():
	var to_player_direction = player.position - position
	# We do not normalize this vector 
	# so that the further away the Searcher is to the Player the higher the attraction
	return to_player_direction * bias_factor


func _increase_bias_on_timeout():
	if bias_factor < bias_cap:
		bias_factor *= bias_change_rate 

	print(bias_factor)	

func _on_Timer_timeout():
	previous_direction = current_direction
	current_direction = choose_random_direction() * force_luke_skywalker

	var force_direction = null
	
	if previous_direction == null:
		force_direction = current_direction
	else:
		var previous_position = position + previous_direction
		force_direction = previous_direction - current_direction
	
	var pb = player_bias()
	var force = (force_direction.normalized() + pb) * force_luke_skywalker
	

	self.linear_velocity = force
	#add_constant_central_force(force)
	
func _process(delta):
	var to_player_direction = player.position - position
	if to_player_direction.length() < self.scale.x*200:
		pass
