extends CanvasLayer


func set_active_weapon(index):
	match index:
		1:
			$MachineGun.set_active(false)
			$Cannon.set_active(true)
		2:
			$MachineGun.set_active(true)
			$Cannon.set_active(false)
		_:
			$MachineGun.set_active(false)
			$Cannon.set_active(false)
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
