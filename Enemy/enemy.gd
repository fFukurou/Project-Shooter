extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


var player
var provoked: bool = false
var aggro_range := 12.0


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta: float) -> void:
	if provoked == true:
		navigation_agent_3d.target_position = player.global_position
	

func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = self.global_position.direction_to(next_position)
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player < self.aggro_range:
		self.provoked = true
	else:
		self.provoked = false
		
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
