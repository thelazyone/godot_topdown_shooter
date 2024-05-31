extends Node3D

# Wasd component is directly controlled by the player and do not require a 
# state machine of any kind (for now)

# Dynamic variables
var plane_direction = 0
var plane_position = Vector2(0, 0)
var wheels_angle = 0  #0 means straight forward.
var steer_acceleration = 5 #deg per sec
var steer_max = .7
var speed = 0
var acceleration = 5
var speed_max = 3
var friction = .5 # must be smaller than acceleration
var steer_restore = 3 #must be smaller than steer_acceleration



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Reading the speed from the real world.
	speed = Geometry.space_to_plane(get_parent().velocity).dot(Vector2(cos(plane_direction), sin(plane_direction)))
	#speed = sign(speed) * Geometry.space_to_plane(get_parent().velocity).length()
	
	# First checking the controls:
	if Input.is_action_pressed("forward"):
		speed += acceleration * delta
		
	if Input.is_action_pressed("steer_left"):
		wheels_angle -= steer_acceleration * delta
		
	if Input.is_action_pressed("steer_right"):
		wheels_angle += steer_acceleration * delta
		
	if Input.is_action_pressed("backwards"):
		speed -= acceleration * delta
		
	# Clamping values
	wheels_angle = clamp(wheels_angle, -steer_max, steer_max)
	speed = clamp(speed, -speed_max, speed_max)
		
	# Applying a slow brake
	speed = sign(speed) * max(0, abs(speed) - friction * delta)
	
	# Applying a wheel reverting to straight
	wheels_angle = sign(wheels_angle) * max(0, abs(wheels_angle) - steer_restore * delta)
	plane_direction += speed * wheels_angle * delta

	# Updating the parent information.
	_update_velocity()
	_update_transforms()
		
	pass
	
func _update_velocity():
		# Updating position and direction based on this.
	get_parent().velocity.x = speed * cos(plane_direction)
	get_parent().velocity.z = speed * sin(plane_direction)
	get_parent().velocity.y = 0 # For now, working on a 2D plane!
	
func _update_transforms():
	get_parent().rotation = Vector3(0, -plane_direction, 0)
