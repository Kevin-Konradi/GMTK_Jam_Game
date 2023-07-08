extends CharacterBody2D


@export var speed_cap: float = 300.0
@export var acceleration: float = .07
var accelerationTimer: float = 0.0
@export var accelerationCurve: Curve
@export var jump_velocity = -500.0
var rate: float = .1
@export var friction = .1

@export var fall_animation_start_threshold = 0.7
@export var walljump_velocity_threshhold = 10
@export var wall_slide_velocity = 100

@export var walk_anim_threshhold = 10

@export var initial_health = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var not_on_floor_time = 0

var is_wall_sliding = false

var health

var moved = false

signal health_changed(new_value)

func _ready():
	health = initial_health
	get_parent().map.connect("ready", teleport_to_spawn)

func _physics_process(delta):
	handle_lateral_movement()
	
	if is_on_floor():
		handle_floor()
	else:
		handle_wall_jump(delta)
	
	move_and_slide()

func teleport_to_spawn():
	position = get_parent().map.spawn.position

func handle_floor():
	$PersistentSlideParticles.emitting = false
	
	if not_on_floor_time > 0: $LandParticles.emitting = true
	not_on_floor_time = 0

	if not is_wall_sliding:
		if velocity.length() < walk_anim_threshhold and is_on_floor():
			$Sprite.play("default")
		else:
			$Sprite.play("walk")

	
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		$Sprite.play("jump")
		
	else:
		$Sprite.play("walk")

func handle_fall(delta):
	velocity.y += gravity * delta
	not_on_floor_time += delta
	
	if not_on_floor_time > fall_animation_start_threshold:
		$Sprite.play("fall")

func handle_fall_not_sliding(delta):
	is_wall_sliding = false
	$PersistentSlideParticles.emitting = false
	handle_fall(delta)

func handle_lateral_movement():
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		if not is_wall_sliding:
			$Sprite.flip_h = direction == -1
		
	if Input.get_action_strength("left") or Input.get_action_strength("right"):
		accelerationTimer += acceleration * rate
	
	accelerationTimer = clamp(accelerationTimer, 0, 1)

	if direction != 0:
		velocity.x += accelerationCurve.sample(accelerationTimer) * speed_cap * direction
		velocity.x = clamp(velocity.x, -speed_cap, speed_cap)
	else:
		accelerationTimer = 0
		velocity.x = lerp(velocity.x, 0.0, friction)


func handle_wall_jump(delta):
	if velocity.y > walljump_velocity_threshhold and is_on_wall_only():
		if velocity.y < wall_slide_velocity:
			handle_fall_not_sliding(delta)
		else:
			is_wall_sliding = true
			not_on_floor_time = 0
			velocity.y = wall_slide_velocity
			var new_direction = get_wall_normal().normalized().x

			if new_direction:
				$Sprite.flip_h = new_direction == -1
				velocity.x = new_direction * -3
			else:
				velocity.x = move_toward(velocity.x, 0, speed_cap)

			# Handle Wall Jump.
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_velocity * 1.4

				if Input.get_action_strength("left") or Input.get_action_strength("right"):
					accelerationTimer = 0
					velocity.x = (-jump_velocity * 2) * new_direction
				else:
					velocity.x = (-jump_velocity * 1.2) * new_direction
				
				$Sprite.play("jump")
			else:
				$Sprite.play("slide")
				
				var x = $PersistentSlideParticles.position.x
				x = abs(x) * -new_direction
				$PersistentSlideParticles.position.x = x
				
				$PersistentSlideParticles.emitting = true
				
	else:
		handle_fall_not_sliding(delta)
		
func take_damage():
	health -= 1
	health_changed.emit(health)
