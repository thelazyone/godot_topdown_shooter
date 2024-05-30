# 2.5D camera, moving along Y plane (Godot's Y is "up")
# Handles the conversion between the actual positions and the XZ 2D coordinates
# 
# Also handles the WASD inputs which move the camera. -> This might be moved
# into a dedicated entity soon, for a cleaner division of roles. TODO!

extends Node3D

var pixelOffset = Vector2(0.0, 0.0)

func coords_on_xz(screen_position):
	var z0_plane  = Plane(Vector3(0, 1, 0), 0)
	var camera_obj = get_node("Camera3D")
	var coords_3d = z0_plane.intersects_ray(
							camera_obj.project_ray_origin(screen_position),
							camera_obj.project_ray_normal(screen_position))
	return Vector2(coords_3d.x, coords_3d.z)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var camera_obj = get_node("Camera3D")
	var camera_speed = 2
	var camera_speed_x = camera_obj.size * camera_speed / camera_obj.get_window().size.y
	var camera_speed_z = camera_obj.size * camera_speed / (camera_obj.get_window().size.y * sin(camera_obj.rotation[0]))
	
	if Input.is_action_pressed("ui_right"):
		pixelOffset.x += camera_speed
		move(Vector3(camera_speed_x, 0, 0))
		
	if Input.is_action_pressed("ui_left"):
		pixelOffset.x -= camera_speed
		move(Vector3(-camera_speed_x, 0, 0))
		
	if Input.is_action_pressed("ui_down"):
		pixelOffset.y -= camera_speed
		move(Vector3(0, 0, -camera_speed_z))
		
	if Input.is_action_pressed("ui_up"):
		pixelOffset.y += camera_speed
		move(Vector3(0, 0, camera_speed_z))

func move(i_vector):
	position += i_vector

