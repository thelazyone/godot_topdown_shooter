# 2.5D camera, moving along Y plane (Godot's Y is "up")
# Handles the conversion between the actual positions and the XZ 2D coordinates
# 
# Also handles the WASD inputs which move the camera. -> This might be moved
# into a dedicated entity soon, for a cleaner division of roles. TODO!

extends Node3D

enum CameraMode {
	Static, 			# Doing Nothing
	WasdControlled,		# Waiting for a target to attack
	FollowTarget, 		# Not attacking, but aiming at a specific point (for debug at least)
	}
var camera_mode = CameraMode.Static
var target_to_follow

@export var SPEED = 2
@export var MOUSE_LOOK_WEIGHT = .05
@export var camera_size_default = 10 # unused for now
@export var camera_size_step = 1
@export var camera_size_min = 5
@export var camera_size_max = 15



func coords_on_xz(screen_position):
	var z0_plane  = Plane(Vector3(0, 1, 0), 0)
	var camera_obj = get_node("Camera3D") 
	var coords_3d = z0_plane.intersects_ray(
							camera_obj.project_ray_origin(screen_position),
							camera_obj.project_ray_normal(screen_position))
	return Vector2(coords_3d.x, coords_3d.z)

func coords_on_target(screen_position):
	const ray_length = 1000
	var camera_obj = get_node("Camera3D")
	var from = camera_obj.project_ray_origin(screen_position)
	var to = from + camera_obj.project_ray_normal(screen_position) * ray_length
	var space_state = get_world_3d().direct_space_state
	
	var params = PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to = to
	params.exclude = []
	params.collision_mask = 255
	var result = space_state.intersect_ray(params)
	print("targeting point: ", result.position)
	return result.position
	

# TODO find a nice way to condense these into one method.

func set_follow(target):
	target_to_follow = target
	print ("Set target to follow as ", target_to_follow)
	camera_mode = CameraMode.FollowTarget
	
func set_static():
	camera_mode = CameraMode.Static

func set_wasd_controlled():
	camera_mode = CameraMode.WasdControlled
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var camera_obj = get_node("Camera3D")
	var camera_speed_x = camera_obj.size * SPEED / camera_obj.get_window().size.y
	var camera_speed_z = camera_obj.size * SPEED / (camera_obj.get_window().size.y * sin(camera_obj.rotation[0]))
	
	if camera_mode == CameraMode.Static:
		pass
	
	# If WASD controlled
	elif camera_mode == CameraMode.WasdControlled:
		if Input.is_action_pressed("ui_right"):
			move(Vector3(camera_speed_x, 0, 0))
			
		if Input.is_action_pressed("ui_left"):
			move(Vector3(-camera_speed_x, 0, 0))
			
		if Input.is_action_pressed("ui_down"):
			move(Vector3(0, 0, -camera_speed_z))
			
		if Input.is_action_pressed("ui_up"):
			move(Vector3(0, 0, camera_speed_z))
		
	elif camera_mode == CameraMode.FollowTarget:
		position = (target_to_follow.position * (1 - MOUSE_LOOK_WEIGHT) + 
			Geometry.plane_to_space(coords_on_xz(get_viewport().get_mouse_position())) * (MOUSE_LOOK_WEIGHT))
		
	# Zooming is done when it's not static
	if camera_mode != CameraMode.Static:
		
		if Input.is_action_just_released("zoom_in"):	
			camera_obj.size = max(camera_obj.size - camera_size_step, camera_size_min)
			
		if Input.is_action_just_released("zoom_out"):
			camera_obj.size = min(camera_obj.size + camera_size_step, camera_size_max)
		

func move(i_vector):
	position += i_vector

