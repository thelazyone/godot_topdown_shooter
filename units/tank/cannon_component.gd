extends Node3D

var is_active = false

# I'm basically implementing a cheap polymorphism by hand here, this doesn't sound right!
# TODO find a better architecture to solve this.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(target_3d):
	if is_active:
		$GunComponent.shoot(target_3d)
