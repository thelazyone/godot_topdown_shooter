extends Node3D

@export var HIT_DAMAGE = 20
@export var HIT_DEVIATION = 10
@export var ATTACK_PERIOD = 100
@export var MAX_SHOOT_ANGLE = 0.1
@export var PROJECTILE: Resource

@export var HAS_TURRET = true
@export var ROT_SPEED = 4


# Combat State:
enum CombatStates {
	Idle, 			# Doing Nothing
	Searching,		# Waiting for a target to attack
	Aiming, 		# Not attacking, but aiming at a specific point (for debug at least)
	Attacking,		# Attacking a target somehow
	AttackingArea,		# Attacking a target somehow
	}
	
var state = CombatStates.Idle
var plane_target = Vector2(0, 0)
var plane_position = Vector2(0, 0)
var turret_direction = 0
var turret_plane_position = Vector2(0,0)
var last_shot_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	plane_position = Vector2(get_parent().position.x, get_parent().position.z)
	turret_plane_position = Vector2(get_node("../Turret").position.x, get_node("../Turret").position.z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	plane_position = Vector2(get_parent().position.x, get_parent().position.z)
	
	# Rotating the turret, if any.
	var target_direction = 0
	var ready_to_shoot = false
	if HAS_TURRET:
		if state == CombatStates.Aiming:
			target_direction = -plane_position.angle_to_point(plane_target)
		elif state == CombatStates.Attacking:
			target_direction = -plane_position.angle_to_point(plane_target) # TODO this should update with the target!
			ready_to_shoot = true
		elif state == CombatStates.AttackingArea:
			target_direction = -plane_position.angle_to_point(plane_target)
			ready_to_shoot = true
		else:
			target_direction = get_parent().rotation.y
			
		turret_direction += clamp(Geometry.diff_angles(target_direction, turret_direction), -ROT_SPEED * delta, ROT_SPEED * delta)
	pass
	
	target_direction = Geometry.wrap_angle(target_direction)
	turret_direction = Geometry.wrap_angle(turret_direction)
	
	# TODO if it doesn't have turret it must rotate entirely instead.
	
	# Checking if the angle to shoot is right:
	if ready_to_shoot and abs(Geometry.diff_angles(target_direction, turret_direction)) > MAX_SHOOT_ANGLE:
		ready_to_shoot = false
	
	if ready_to_shoot:
		if Time.get_ticks_msec() - last_shot_time > ATTACK_PERIOD :
			last_shot_time = Time.get_ticks_msec()
			_shoot(plane_target)
	
	
# Shooting at target with scatter. Spawns a projectile that will then behave as it should.
func _shoot(target):
	
	# If projectile is missing, ignoring
	if PROJECTILE: 
		
	
		var new_projectile = PROJECTILE.instantiate()
		new_projectile.position = position
		new_projectile.set_target(plane_position + turret_plane_position, target, HIT_DEVIATION)
		new_projectile.set_shell_offset(get_node("../Turret").position)
		add_child(new_projectile)
		
	pass

# State commands
func combat_aim(coordinates):
	state = CombatStates.Aiming
	plane_target = coordinates
	
func combat_attack_area(coordinates):
	state = CombatStates.AttackingArea
	plane_target = coordinates
	
	# TODO set a timer: 
	
func combat_stop():
	state = CombatStates.Idle
	plane_target = Vector2(0, 0)
