extends CharacterBody3D


@export var BULLET_SPEED = 40
@export var LIFETIME = 5000
@export var START_SHOW = 5
@export var EXPLOSION: Resource


var spawn_time = Time.get_ticks_msec()
var shell_offset = Vector2(0, 0)
var deviation = Vector3(0,0,0)

func set_target(i_position, i_target, i_deviation):
	
	# Velocity direction is calculated on the target.
	velocity = Vector3(BULLET_SPEED, 0, 0).rotated(Vector3(0,1, 0), -i_position.angle_to_point(i_target))
	
	# A box rand deviation, while not uniform, should work just fine.
	# The correct one would use normal distributions on the 3 dimensions, but it's more expensive 
	# and doesn't bring extra benefits
	deviation = Vector3(randf_range(-i_deviation,i_deviation),randf_range(-i_deviation,i_deviation),randf_range(-i_deviation,i_deviation))


# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.


func _physics_process(delta):
	var elapsed = Time.get_ticks_msec() - spawn_time
	visible = elapsed > START_SHOW
	get_node("CollisionShape3D").disabled = !visible

	# If hits something, it disappears
	if get_slide_collision(0) != null:
		var target = get_slide_collision(get_slide_collision_count() - 1)
		explode()

	# Bullet disappears after maximum range @TODO should explode?
	if elapsed > LIFETIME:
		explode()
		
	if global_position.y < 0:
		explode()
		
	velocity += deviation * delta
	move_and_slide()
	pass
	

func explode():
	var explosion = EXPLOSION.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)
	queue_free()
