extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -500.0
@export var fall_animation_start_threshold = 0.7


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var not_on_floor_time = 0

func _physics_process(delta):
	if is_on_floor():
		handle_floor()
	else:
		handle_fall(delta)

	handle_lateral_movement()
		
	move_and_slide()

func handle_floor():
	if not_on_floor_time > 0: $Particles.emitting = true
	not_on_floor_time = 0
	
	if velocity == Vector2.ZERO:
		$Sprite.play("default")
	else:
		$Sprite.play("walk")
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		$Sprite.play("jump")

func handle_fall(delta):
	velocity.y += gravity * delta
	not_on_floor_time += delta
	
	if not_on_floor_time > fall_animation_start_threshold:
		$Sprite.play("fall")
		
func handle_lateral_movement():
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		$Sprite.flip_h = direction == -1
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
