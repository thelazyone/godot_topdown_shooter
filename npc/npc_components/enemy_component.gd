extends Node3D

# Implementing a basic state machine:
enum States {
	Idle, 			# Doing Nothing
	Attacking, 		# Reaching point x,y
	Pinned,		# Following something with ID
	}
var state = States.Idle	
@export var PINNED_DURATION_MS = 3000 
var pinned_timeout = 0

# STATE READ

func is_attacking():
	return state == States.Attacking

# EFFECTS
func enemy_spotted():
	if state == States.Idle:
		state = States.Attacking

func pin():
	state = States.Pinned
	pinned_timeout = PINNED_DURATION_MS
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Unpinning if pinned and time has passed
	if state == States.Pinned:
		pinned_timeout -= delta
		if pinned_timeout <= 0:
			state = States.Idle
