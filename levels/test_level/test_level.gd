# World is the base node and has no role. Only check necessary is to quit the game
# if the X button is pressed. 

extends Node3D

func add_sphere(coords):
	var sphere_node = preload("res://levels/level_assets/sphere_rigid.tscn").instantiate()
	sphere_node.position = coords
	add_child(sphere_node)
	
func add_cube(coords):
	var cube_node = preload("res://levels/level_assets/cube_rigid.tscn").instantiate()
	cube_node.position = coords
	add_child(cube_node)

func add_enemy(target, coords):
	var cube_node = preload("res://npc/enemy/enemy.tscn").instantiate()
	cube_node.position = coords
	cube_node.set_target(target)
	add_child(cube_node)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tank_node = preload("res://units/tank/tank.tscn").instantiate()
	add_child(tank_node)
	get_node("/root/World/CameraBase").set_follow(tank_node)
	
	# Adding spheres around
	add_sphere(Vector3(5,0,5))
	add_sphere(Vector3(3,0,1))
	add_sphere(Vector3(5,0,1))
	add_sphere(Vector3(1,0,5))
	add_sphere(Vector3(1,0,3))
	add_sphere(Vector3(2,0,7))
	
	# Adding Cubes
	for i in range(10):
		for j in range(10):
			add_cube(Vector3(0 + i*.3, 1, 3+ j*.3))
		
	
	# Adding Enemies
	for i in range(5):
		for j in range(5):
			add_enemy(tank_node, Vector3(-12 + i, 0, -12 + j))
	
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
