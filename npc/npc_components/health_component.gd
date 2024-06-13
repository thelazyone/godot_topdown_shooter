extends Node3D

@export var health = 30.
@onready var curr_health : float = health


# Receiving Damage
func receive_damage(value):
	curr_health -= value
	if curr_health <= 0:
		get_parent().die()
		
# Gets
func get_health():
	return curr_health

func get_max_health():
	return health

func get_health_perc():
	return curr_health / health


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
