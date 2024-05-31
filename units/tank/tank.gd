extends CharacterBody3D


var is_selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connecting the mouse shoot component to the Turret and setting its position
	get_node("MouseShootComponent").aim_order.connect(get_node("Turret/TurretComponent").aim_to)
	get_node("MouseShootComponent").shoot_main_order.connect(get_node("Turret/GunComponent").shoot)

func _physics_process(delta):
	
	# Previously using move_and_slide, but sliding looks very weird on wheeled vehicles
	var collision = move_and_collide(velocity * delta)
	if collision:
		# First bounce, then push the target a bit
		velocity += velocity.bounce(collision.get_normal()) * collision.get_collider().mass
		collision.get_collider().apply_impulse(-collision.get_normal() * collision.get_collider().mass)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass

func command_move(target):
	get_node("MoveComponent").command_move(target)

# Selection methods
func select(bool_value):
	is_selected = bool_value
	get_node("Selected").visible = is_selected
	
	
func combat_aim(target):
	get_node("CombatComponent").combat_aim(target)
	
	
func combat_stop():
	get_node("CombatComponent").combat_stop()
	
	
func combat_attack_area(target):
	get_node("CombatComponent").combat_attack_area(target)
	
