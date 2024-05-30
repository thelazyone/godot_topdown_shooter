# Handles the instancing of all the entities in the game. Mostly Units, Terrain and Bullets.
#
# TODO: as a Hack, i'm currently overwriting some properties of the meshes (the shine in particular)
# and since I'm doing that right before instantiating them I'm doing that here. It's dirty.
extends Node3D


# Creating a reference to the other useful parts. The @onready holds the definition until the 
# _ready function has been called and the system initialized.
#@onready var m_UnitsControlNode = get_node("../UnitsControl")
@onready var m_Camera = get_node("../CameraBase")


# Called when the node enters the scene tree for the first time.
# TODO Note that some comands are still to be implemented.
func _ready():
	print("hello")
	## Active actors orders
	#m_UnitsControlNode.movement_order.connect(go_to)
	#m_UnitsControlNode.area_selected.connect(select_actors)
	#m_UnitsControlNode.aim_order.connect(aim_to)
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Nothing to do here.
	pass


# All Commands go through this node, because it is the only one to have a list
# of All the actors. 

# Units Commands
func go_to(coordinate):
	
	# First calculating the amount of elements to move:
	var total_elements = 0
	var plane_baricenter = Vector3(0, 0, 0)
	for child in get_children():
		if "is_selected" in child and child.is_selected:
			total_elements = total_elements + 1
			
			# Calculating the baricenter. TODO make an autoload with geometry functs.
			plane_baricenter = plane_baricenter + child.position
	
	plane_baricenter = plane_baricenter / total_elements
	
	# TODO implement a better group pathfinding.
	
	# TODO move the units in a grid 
	for child in get_children():
		if "is_selected" in child and child.is_selected:
			child.command_move(m_Camera.coords_on_xz(coordinate))


func select_actors(start, end):
	var plane_start = m_Camera.coords_on_xz(start)
	var plane_end = m_Camera.coords_on_xz(end)
	for child in get_children():
		if child.has_method("select"):
			# STUPID method, clearly not the correct one.
			var select_value = child.position.x > plane_start.x and child.position.x < plane_end.x and child.position.z > plane_start.y and child.position.z < plane_end.y
			child.select(select_value)


func aim_to(coordinate):
	for child in get_children():
		if child.has_node("CombatComponent"):
			if "is_selected" in child and child.is_selected:
				child.combat_aim(m_Camera.coords_on_xz(coordinate))
			else:
				child.combat_stop()


func shoot_area(coordinate):
	for child in get_children():
		if child.has_node("CombatComponent"):
			if "is_selected" in child and child.is_selected:
				child.combat_attack_area(m_Camera.coords_on_xz(coordinate))
			else:
				child.combat_stop()

func add_tank(coordinate): # Clearly temp:
	var new_tank = get_node("tank").instantiate()
	new_tank.position = Geometry.plane_to_space(m_Camera.coords_on_xz(coordinate))
	add_child(new_tank)









