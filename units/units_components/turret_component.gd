extends Node3D

# All the logic to control a turret goes here.
# This exposed turret-specific parameters, and handles the pan-tilt of the individual
# turret.
# It does NOT emit any signal, and rather it requires a gentle polling to check when to shoot.

var turret_direction = 0
var ready_to_shoot = false

# Note that positions are RELATIVE. You must calculate the positions, but from the point of
# view of the turret everything that happens outside is irrelevant.
var position_2d = Vector2(0,0)
var target_position_2d = Vector2(0,0)
@export var TURRET_ROT_SPEED = 2
@export var MAX_SHOOT_ANGLE = 0.1

# Calling aim_to, where RELATIVE coordinates are given.
func aim_to(coordinate_2d):
	target_position_2d = coordinate_2d

# Called when the node enters the scene tree for the first time.
func _ready():
	# The turret position is provided by the parent node (which contains the mesh as well)
	call_deferred("_set_position")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var target_direction = 0
	
	# If the target is too close, ignoring, to prevent weird rotations.
	if position_2d.distance_to(target_position_2d) > 0.1:
		target_direction = Geometry.wrap_angle(Geometry.diff_angles(position_2d.angle_to_point(target_position_2d), -global_rotation.y))
		
		# Calculating the new angle, wrapping it around the circle, and checking if ready to shoot.
		turret_direction += clamp(target_direction, -TURRET_ROT_SPEED * delta, TURRET_ROT_SPEED * delta)
		target_direction = Geometry.wrap_angle(target_direction)
		turret_direction = Geometry.wrap_angle(turret_direction)
		ready_to_shoot = abs(Geometry.diff_angles(target_direction, turret_direction)) < MAX_SHOOT_ANGLE
	
	_update_transforms()
	
func _update_transforms():
	get_parent().rotation = Vector3(0, -turret_direction, 0)
	
func _set_position():
	position_2d = Geometry.space_to_plane(get_parent().position)
	print("setting position2d to ", get_parent().position)
