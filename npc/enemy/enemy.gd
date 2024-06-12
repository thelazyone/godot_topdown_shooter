extends CharacterBody3D

var target = null
@export var target_path : NodePath
@onready var nav_agent = $NavigationAgent3D

const SPEED = 2.0
const INERTIA = .8
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func set_target(new_target): 
	target = new_target
	
# Adding this to the characterbody - TODO this is not the right way to do this
# Should be changed as soon as possible.
func apply_impulse(vector):
	velocity += Geometry.space_to_space_flat(vector) * 50


func _process(delta):
	#velocity = Vector3.ZERO
	
	if target:
		nav_agent.set_target_position(target.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity *= INERTIA
		velocity += (1 - INERTIA) * (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
