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
func _ready():

	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Nothing to do here.
	pass


# All Commands go through this node, because it is the only one to have a list
# of All the actors. 
