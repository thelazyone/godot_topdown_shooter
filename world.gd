# World is the base node and has no role. Only check necessary is to quit the game
# if the X button is pressed. 

extends Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Loading level:
	var level = preload("res://levels/test_level/test_level.tscn").instantiate()
	add_child(level)
	
	# Connecting Buttons to Actors spawner
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

func _input(event):
	# Quit on "Esc"
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_add_tank_pressed():
	pass # Replace with function body.
