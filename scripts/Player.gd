extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -500.0
@export var fall_animation_start_threshold = 0.7


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var not_on_floor_time = 0

func _physics_process(delta):
	if is_on_floor():
		if not_on_floor_time > 0: $Particles.emitting = true
		
		not_on_floor_time = 0
	else:
		velocity.y += gravity * delta
		not_on_floor_time += delta
		
		if not_on_floor_time > fall_animation_start_threshold:
			$Sprite.play("fall")

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		$Sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		$Sprite.flip_h = direction == -1
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if velocity == Vector2.ZERO and is_on_floor():
		$Sprite.play("default")
	else:
		$Sprite.play("walk")
		
	move_and_slide()
	
