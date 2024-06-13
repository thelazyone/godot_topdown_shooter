extends ColorRect


func set_active(is_active):
	if is_active: 
		set_color(Color(.5, 1., .5, 1.))
	else:
		set_color(Color(1., .5, .5, 1.))
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
