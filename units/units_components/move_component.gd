extends Node3D

# The state machine of the movement orders for the actor using this component.
# This is a work in progress that might change further on.
enum ActionStates {
	Idle, 			# Doing Nothing
	Moving, 		# Reaching point x,y
	Following,		# Following something with ID
	Interacting,	# Either reaching something with ID or - if reached - interacting.
	}
	
var state = ActionStates.Idle

# Some states rely on a target, which could be a point on the screen or an object.
# TODO maybe condense the two in a single enum (or what GDScript allows)?
var target = Vector2(0, 0)
var target_obj = null

# Direction and position of the actor on the XZ plane.
var plane_direction = 0
var plane_position = Vector2(0, 0)

# Parameters visible from outside. To be updated after this.
@export var SPEED = 200
@export var ROT_SPEED = 5
@export var MIN_ANGLE_MOVE = PI / 4
@export var target_distance_threshold = 0.1
@export var interaction_range = 0.5


# Process function. Called every frame.
# 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Updating the plane position and target point:
	plane_position = Vector2(get_parent().position.x, get_parent().position.z)
	target = Geometry.space_to_plane(nav_agent.get_next_path_position())
		
	if state == ActionStates.Idle:
		pass
	
	elif state == ActionStates.Moving:
		if !_move_towards(target, delta, target_distance_threshold):
			command_stop()
		
	elif state == ActionStates.Interacting:
		# Updating the target, moving toward, then trying to interact if in range
		if target_obj == null: 
			print ("Target is null and state is Following!")
		else:
			target = Vector2(target_obj.position.x, target_obj.position.z) 
		_move_towards(target, delta, target_distance_threshold)
		if !_interact_with(target, delta, interaction_range):
			command_stop()
	
	elif state == ActionStates.Following:
		# Updating the target position then moving.
		if target_obj == null: 
			print ("Target is null and state is Following!")
		else:
			target = Vector2(target_obj.position.x, target_obj.position.z) 
		_move_towards(target, delta, target_distance_threshold)
		
	pass


# Private functions to handle the movement.

# Movement towards target - TODO check for collisions using Godot tools
func _move_towards(target, delta, threshold):
	
	# Resetting velocity to default:
	get_parent().velocity.x = 0
	get_parent().velocity.z = 0
		
	# If the distance is small enough, skipping the move.
	if plane_position.distance_to(target) < target_distance_threshold:
		return false
	
	# First rotating if not rotated.
	var target_direction = plane_position.angle_to_point(target)
	
	plane_direction += clamp(Geometry.diff_angles(target_direction, plane_direction), -ROT_SPEED * delta, ROT_SPEED * delta)
	
	# If the difference in angle is not excessive
	if abs(Geometry.diff_angles(target_direction, plane_direction)) < MIN_ANGLE_MOVE:
		get_parent().velocity.x = SPEED * cos(plane_direction) * delta
		get_parent().velocity.z = SPEED * sin(plane_direction) * delta
		
	# Updating the navigation agent as well.
	nav_agent.set_velocity(Geometry.plane_to_space(get_parent().velocity))
	
	_update_transforms()
	return true


func _interact_with(target, delta, range):
	
	# TODO to implement.
	
	var interaction_successful = true
	# TODO return false if the interaction is not necessary anymore.
	
	return interaction_successful


# Apply the component's direction to the parent object. Should there be a better way?
func _update_transforms():
	get_parent().rotation = Vector3(0, -plane_direction, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	plane_position = Vector2(get_parent().position.x, get_parent().position.z)


# Public Functions Here

func command_move(i_target):
	state = ActionStates.Moving
	update_target_location(Geometry.plane_to_space(i_target))
	print ("Send command Move towards", i_target)


func command_interact(i_target_obj):
	# TODO check if target is a valid target.
	state = ActionStates.Interacting
	target_obj = i_target_obj
	update_target_location(target_obj.position)
	print ("Send command Interact")


func command_stop():
	state = ActionStates.Idle
	target = Vector2(0, 0)
	print ("Send command Stop")


func command_follow(i_target_obj):
	# TODO check if target is a valid target.
	state = ActionStates.Following
	target_obj = i_target_obj
	update_target_location(target_obj.position)
	print ("Send command Follow")


# Pathfinding navigation
@onready var nav_agent = $NavigationAgent3D
func update_target_location(location):
	nav_agent.set_target_position(location)
