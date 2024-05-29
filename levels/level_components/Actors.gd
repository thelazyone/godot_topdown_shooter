# Handles the instancing of all the entities in the game. Mostly Units, Terrain and Bullets.
#
# TODO: as a Hack, i'm currently overwriting some properties of the meshes (the shine in particular)
# and since I'm doing that right before instantiating them I'm doing that here. It's dirty.
extends Node3D


# Creating a reference to the other useful parts. The @onready holds the definition until the 
# _ready function has been called and the system initialized.
@onready var m_UnitsControlNode = get_node("../UnitsControl")
@onready var m_Camera = get_node("../CameraBase")


# Called when the node enters the scene tree for the first time.
# TODO Note that some comands are still to be implemented.
func _ready():
	
	# Active actors orders
	m_UnitsControlNode.movement_order.connect(go_to)
	m_UnitsControlNode.area_selected.connect(select_actors)
	m_UnitsControlNode.aim_order.connect(aim_to)
	
	# Building Units orders
	m_UnitsControlNode.build_worker_order.connect(add_worker)
	m_UnitsControlNode.build_tank_order.connect(add_tank)
	m_UnitsControlNode.build_factory_order.connect(build_factory)
	m_UnitsControlNode.build_plant_order.connect(build_plant)


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


# Build Units commands
func add_worker(coordinate):
	pass
	#var new_worker = preload("res://Scenes/worker.tscn").instantiate()
	#new_worker.position = Geometry.plane_to_space(m_Camera.coords_on_xz(coordinate))
	#adjust_materials(new_worker, 0.0)
	#add_child(new_worker)


func add_tank(coordinate): # Clearly temp:
	var new_tank = get_node("tank").instantiate()
	new_tank.position = Geometry.plane_to_space(m_Camera.coords_on_xz(coordinate))
	adjust_materials(new_tank, 0.25)
	add_child(new_tank)


# Build Buildings commands
func build_factory(coordinate): 
	pass
	#var new_fact = preload("res://Scenes/factory.tscn").instantiate()
	#new_fact.position = Geometry.plane_to_space(m_Camera.coords_on_xz(coordinate))
	#adjust_materials(new_fact, 0.)
	#add_child(new_fact)


func build_plant(coordinate): 
	pass
	#var new_plant = preload("res://Scenes/plant.tscn").instantiate()
	#new_plant.position = Geometry.plane_to_space(m_Camera.coords_on_xz(coordinate))
	#adjust_materials(new_plant, 0.)
	#add_child(new_plant)


# Shine Material adjustment. It should NOT be here. TODO.
# Shine Factor
@export var SHINE_FACTOR = 0.6

# Sets the general reflection of the meshes of the created actors. 
# Might benefit being in a separate object. For now let's keep it here.
func adjust_materials(node, lightness_factor : float = 0.0):

	var desired_roughness = 1. - SHINE_FACTOR
	var desired_specular = 0.

	if node is MeshInstance3D and node.get_active_material(0) is StandardMaterial3D:
		var material = node.get_active_material(0) as StandardMaterial3D
		print("Setting roughness to", desired_roughness)
		material.roughness = desired_roughness
		material.specular = desired_specular
				#material.albedo_color = Color(1,1,1,1)
		if lightness_factor>0.1 :
			print("Increasing emission to ", lightness_factor, "for ", node)
			material.emission_enabled = true
			material.emission = Color(lightness_factor,lightness_factor,lightness_factor,1)
			
	elif node is MeshInstance3D:
		var mesh = node.mesh
		if mesh:
			for i in range(mesh.get_surface_count()):
				var material = mesh.surface_get_material(i)
				if material and material is StandardMaterial3D:
					material.roughness = desired_roughness
					material.specular = desired_specular
				
	# Recursively adjust materials for all children of the current node
	for child in node.get_children():
		adjust_materials(child, lightness_factor)










