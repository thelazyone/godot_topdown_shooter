extends Node

@onready var gui_node = get_node("/root/World/GUI")

func set_active_weapon(index):
	gui_node.set_active_weapon(index)
