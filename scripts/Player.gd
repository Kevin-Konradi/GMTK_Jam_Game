extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -500.0
@export var fall_animation_start_threshold = 0.7
@export var walljump_velocity_threshhold = 10
@export var wall_slide_velocity = 100


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var not_on_floor_time = 0

var is_wall_sliding = false


func _physics_process(delta):
	handle_lateral_movement()
	
	if is_on_floor():
		handle_floor()
	else:
		handle_wall_jump(delta)
	
	move_and_slide()


func handle_floor():
	if not_on_floor_time > 0: $Particles.emitting = true
	not_on_floor_time = 0
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		
	elif velocity == Vector2.ZERO:
		$Sprite.play("default")
		
	else:
		$Sprite.play("walk")
		
	if not is_wall_sliding:
		if velocity == Vector2.ZERO and is_on_floor():
			$Sprite.play("default")
		else:
			$Sprite.play("walk")


func handle_fall(delta):
	velocity.y += gravity * delta
	not_on_floor_time += delta
	
	if not_on_floor_time > fall_animation_start_threshold:
		$Sprite.play("fall")


func handle_lateral_movement():
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		if not is_wall_sliding:
			$Sprite.flip_h = direction == -1
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func handle_wall_jump(delta):
	if velocity.y > walljump_velocity_threshhold and is_on_wall_only():
		if velocity.y < wall_slide_velocity:
			is_wall_sliding = false
			handle_fall(delta)
		else:
			is_wall_sliding = true
			velocity.y = wall_slide_velocity
			var new_direction = get_wall_normal().normalized().x

			if new_direction:
				$Sprite.flip_h = new_direction == -1
				velocity.x = new_direction * -3
			else:
				velocity.x = move_toward(velocity.x, 0, speed)

			# Handle Wall Jump.
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_velocity
				velocity.x = (-jump_velocity * 3) * new_direction
				$Sprite.play("jump")
				
	else:
		is_wall_sliding = false
		handle_fall(delta)
