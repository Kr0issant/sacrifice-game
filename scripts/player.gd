extends CharacterBody2D

@onready var player_sprite = $AnimatedSprite2D
@export var SPEED: float = 100
@export var SPRINT_MULT: float = 2

var is_sprinting = false

var input: Vector2
enum animationStateEnum{
	DOWN,
	UP,
	SIDE
}
var animationState := animationStateEnum.DOWN

func get_input():
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	return input.normalized()
	
var playerInput: Vector2:
	set(value):
		if playerInput.y > 0:
			animationState = animationStateEnum.DOWN
		elif playerInput.y < 0:
			animationState = animationStateEnum.UP
		elif playerInput.x != 0:
			animationState = animationStateEnum.SIDE
		playerInput = value

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if Input.is_action_just_pressed("sprint"):
		is_sprinting = true
		SPEED *= SPRINT_MULT
	if Input.is_action_just_released("sprint"):
		is_sprinting = false
		SPEED /= SPRINT_MULT
	
	playerInput = get_input()
	#Handle Horizontal movement
	if playerInput.x:
		velocity.x = playerInput.x * SPEED
		if playerInput.x < 0:
			player_sprite.flip_h = true
		else:
			player_sprite.flip_h = false
		if playerInput.y == 0:
			if is_sprinting:
				player_sprite.play("run_side")
			else:
				player_sprite.play("walk_side")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) #Bring to rest
		if animationState == animationStateEnum.SIDE:
			player_sprite.play("idle_side")
	#Handle Vertical movement
	if playerInput.y:
		velocity.y = playerInput.y * SPEED
		if playerInput.y < 0:
			if is_sprinting:
				player_sprite.play("run_back")
			else:
				player_sprite.play("walk_back")
		else:
			if is_sprinting:
				player_sprite.play("run_front")
			else:
				player_sprite.play("walk_front")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED) #Bring to rest
		match animationState:
			animationStateEnum.UP:
				player_sprite.play("idle_back")
			animationStateEnum.DOWN:
				player_sprite.play("idle_front")

	move_and_slide()
