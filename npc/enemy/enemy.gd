extends CharacterBody3D

var target = null
@onready var nav_agent = $NavigationAgent3D

@export var SPEED = 2.0
@export var INERTIA = .8
@export var JUMP_VELOCITY = 4.5
@export var VIEW_RANGE = 3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var material = $MeshInstance3D.get_mesh().surface_get_material(0).duplicate()

func set_target(new_target): 
	target = new_target
	
# Adding this to the characterbody - TODO this is not the right way to do this
# Should be changed as soon as possible.
func apply_impulse(vector):
	velocity += Geometry.space_to_space_flat(vector) * 50

func die():
	print ("Enemy killed!")
	queue_free()

func _process(delta):
	
	# Checking the state of the EnemyComponent
	if $EnemyComponent.is_attacking() and target:
		nav_agent.set_target_position(target.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity *= INERTIA
		velocity += (1 - INERTIA) * (next_nav_point - global_transform.origin).normalized() * SPEED
		rotation = Geometry.plane_angle_from_vector(velocity)
		move_and_slide()
	
	# Checking if the opponent is within check limit.
	elif (target.global_transform.origin - global_transform.origin).length() < VIEW_RANGE:
		$EnemyComponent.enemy_spotted()
		
	# Setting the colour based on the health
	var targetColor = Color(\
		1.,\
		$HealthComponent.get_health_perc(), \
		$HealthComponent.get_health_perc(), \
		1.)
	material.albedo_color = targetColor
	$MeshInstance3D.set_surface_override_material(0, material)
