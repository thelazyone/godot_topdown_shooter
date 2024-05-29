extends RigidBody3D

@export var AREA = 1
@export var DAMAGE = 20
@export var DURATION = 100

var spawn_time = Time.get_ticks_msec()

func _ready():
	get_node("CollisionShape3D").scale *= AREA
	get_node("MeshInstance3D").scale *= AREA
	

	
func _physics_process(delta):
	# Add the gravity.
	var elapsed = Time.get_ticks_msec() - spawn_time
	if elapsed > DURATION:
		queue_free()
	
	#Damage is dealt now.
	var targets = get_colliding_bodies()
	for target in targets:
		# TODO NOTIFY DAMAGE DEALT
		print ("damaged target ", target)
