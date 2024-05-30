# World is the base node and has no role. Only check necessary is to quit the game
# if the X button is pressed. 

extends Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tank_node = preload("res://units/tank/tank.tscn").instantiate()
	add_child(tank_node)
	get_node("/root/World/CameraBase").set_follow(tank_node)
		
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
