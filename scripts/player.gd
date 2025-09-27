extends CharacterBody2D

@export var speed = 150.0

# It's cleaner to get a direct reference to the nodes
@onready var animated_sprite = $AnimatedSprite2D
@onready var navigation_agent = $NavigationAgent2D

func _physics_process(delta):
	# --- 1. SET THE TARGET ON CLICK ---
	# This is the only thing that should happen on the click itself.
	if Input.is_action_just_pressed("left_click"):
		navigation_agent.target_position = get_global_mouse_position()

	# --- 2. CHECK IF WE HAVE ARRIVED ---
	# If the agent's path is finished, stop moving and play an idle animation.
	if navigation_agent.is_target_reached():
		velocity = Vector2.ZERO
		# A simple way to play an idle animation without it constantly restarting
		if not animated_sprite.animation.contains("idle"):
			animated_sprite.play("idle_front")
		return # Stop further processing if we've arrived

	# --- 3. CALCULATE DIRECTION AND VELOCITY ---
	# Get the next point on the path and calculate the direction to it.
	var next_path_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	
	# This is the correct way to set velocity: direction * speed
	velocity = direction * speed

	# --- 4. HANDLE ANIMATIONS BASED ON DIRECTION ---
	# We check which direction (horizontal or vertical) is stronger to decide the animation.
	if abs(direction.x) > abs(direction.y):
		# Moving mostly sideways
		animated_sprite.play("walk_side")
		animated_sprite.flip_h = direction.x < 0 # Flip if moving left
	else:
		# Moving mostly vertically
		animated_sprite.flip_h = false
		if direction.y > 0:
			# Moving down
			animated_sprite.play("walk_front")
		else:
			# Moving up
			animated_sprite.play("walk_back")
			
	# --- 5. MOVE THE CHARACTER ---
	move_and_slide()
