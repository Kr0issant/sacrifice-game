extends CharacterBody2D

# Give the script a class_name to access its enum from other scripts
class_name Ally 

@export var speed = 70.0
@export var follow_distance = 120.0
@export var player_node: CharacterBody2D

enum State { IDLE, FOLLOWING, ATTACKING }
var current_state = State.IDLE

@onready var navigation_agent = $NavigationAgent2D
@onready var selection_area = $SelectionArea
# A reference to your main script to call the selection function
@onready var main_controller = get_tree().root.get_node("Main")

func _ready():
	selection_area.input_event.connect(_on_selection_area_input_event)

# This is the new public function to change the state
func set_state(new_state: State):
	current_state = new_state
	print("Ally state set to: ", State.keys()[new_state])

func _physics_process(delta):
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO

		State.FOLLOWING:
			if global_position.distance_to(player_node.global_position) > follow_distance:
				navigation_agent.target_position = player_node.global_position
			else:
				# If close enough, stop moving
				velocity = Vector2.ZERO
				move_and_slide()
				return
			
			# Movement logic
			if not navigation_agent.is_target_reached():
				var direction = global_position.direction_to(navigation_agent.get_next_path_position())
				velocity = direction * speed
			else:
				velocity = Vector2.ZERO
		
		State.ATTACKING:
			velocity = Vector2.ZERO
			# Add attack logic here

	move_and_slide()

# --- Selection Logic ---
func _on_selection_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# Tell the main controller that this ally has been selected
		main_controller.select_ally(self)

func select():
	# Add a visual indicator, like a highlight
	$selection_indicator.show() 

func deselect():
	# Remove the visual indicator
	$selection_indicator.hide()
