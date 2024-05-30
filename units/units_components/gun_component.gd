extends Node3D

@export var PROJECTILE: Resource
@export var HIT_DAMAGE = 20 # TODO unused for now
@export var HIT_DEVIATION = 0.1
@export var COOLDOWN = 500

var last_shot_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Coordinates must be 
func shoot(target):
	
	var time_now = Time.get_ticks_msec()
	print(time_now - last_shot_time)
	if PROJECTILE and time_now - last_shot_time > COOLDOWN:
		var new_projectile = PROJECTILE.instantiate()
		new_projectile.position = global_position
		print ("setting bullet position to ", new_projectile.position)
		new_projectile.set_target(Vector2(0,0), target, HIT_DEVIATION)
		
		get_node("/root/World/Actors").add_child(new_projectile)
		
		# Updating the shoot time for the cooldown
		last_shot_time = time_now
