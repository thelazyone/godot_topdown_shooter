extends Area3D

@export var AREA = 5.
@export var DAMAGE = 20
@export var DURATION = 100

var spawn_time = Time.get_ticks_msec()
var is_damage_dealt = false

func calculate_damage(range):
	if AREA > 2:
		var range_ratio = 2 * range / AREA
		return max(0, (1 - range_ratio)) * DAMAGE
	return DAMAGE

func _ready():
	get_node("CollisionShape3D").scale *= AREA
	get_node("MeshInstance3D").scale *= AREA
	
func _physics_process(delta):
	if not is_damage_dealt:
		is_damage_dealt = true
		var targets = get_overlapping_bodies()
		for target in targets:
			if target is RigidBody3D or target is CharacterBody3D:
				var direction = (target.global_position - global_position).normalized()
				var strength = clamp(1/(target.global_position - global_position).length(), 0, 1) * DAMAGE * 0.01
				target.apply_impulse(direction * strength)
			
			var health_node = target.get_node_or_null("HealthComponent")
			if health_node:
				health_node.receive_damage(calculate_damage((target.global_position - global_position).length()))
	
	# Add the limited duration explosion effect..
	var elapsed = Time.get_ticks_msec() - spawn_time
	if elapsed > DURATION:
		queue_free()
		
