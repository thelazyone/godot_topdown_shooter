extends Node3D

# Controlling what the mouse does for the player.
# I've decided to attach this directly to the main character, rather than handling
# this in the UnitsControl. This is a shift of paradigm that might bite me in the future
# but for now it seems more idiomatic of the engine.

var mousePos = Vector2()
var combat_enabled = true # Simple "combat enabled" flag. Useful for cutscenes and such.
var last_click_start = 0 # Loading gun shoot (must hold click a little bit)

# Signals
signal aim_order(location)
signal shoot_main_order(location)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	# Drawing area if the mouse is dragging.
	if event is InputEventMouse:
		# Polling this, might be very inefficient.
		mousePos = get_node("/root/World/CameraBase").coords_on_xz(event.position)
		
		# TODO for the future an "emit" should be better, but this implies sending
		# the ABSOLUTE position in 3D instead of the relative one
		aim_order.emit(mousePos - Geometry.space_to_plane(get_parent().position))
			# If click, there might be a command sent.
	if event is InputEventMouseButton and event.button_index == 1:
		
		# First asking the turret if it's in position:
		if get_node("../Turret/TurretComponent").is_ready():
			shoot_main_order.emit(get_node("/root/World/CameraBase").coords_on_target(event.position))
