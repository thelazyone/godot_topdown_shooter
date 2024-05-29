# An overlay to the 3D camera, whhich displays 2D controls such as the drag-and-drop and the
# command buttons.
# The command buttons implement a simple state machine which keeps the last command 
# issued until a cancel order arrives.
#
# TODO: Split drag rect and buttons in two different entities.
extends CanvasLayer


# Drag Rectangle Logic:
# Rectangle handling. Basic geometry.
var rectStart = Vector2()
var isDragging = false
var mousePos = Vector2()


# Rectangle signals
signal area_selected(start_point, end_point)
signal movement_order(location)
signal interact_order(location) # TODO or object???
signal aim_order(location)


func draw_area(show = true):
	var rectangle = get_node("./Rect")
	rectangle.visible = show
	if show:
		rectangle.position = Vector2(min(rectStart.x, mousePos.x), min(rectStart.y, mousePos.y))
		rectangle.size = Vector2(abs(rectStart.x - mousePos.x), abs(rectStart.y - mousePos.y))


# Button Commands Logic: 

# All the possible ongoing commands: only one at a time!
enum ImpendingCommand {
	None, 			# No command given
	BuildWorker, 		# Build a worker at the next click
	BuildTank, 		# Build a worker at the next click
	BuildFactory,		# Build a factory at the next click
	BuildPlant,			# Build a plant at the next click
	}
var command = ImpendingCommand.None
 

# If there is a location and an impending command, it sends a signal to perform the action.
signal build_worker_order(location)
signal build_tank_order(location)
signal build_factory_order(location) # Obviously this will be made generic later on
signal build_plant_order(location)


# Standard callbacks:

# Called when the node enters the scene tree for the first time.
func _ready():
	# Nothing to be done here.
	pass
	
func _input(event):
	
	# Drawing area if the mouse is dragging.
	if event is InputEventMouse:
		
		# Before calculating the drag, checking if the mouse is down.
		# This ensures that if the correct state flow is lost the rect is not shown.
		if event is InputEventMouseMotion:
			if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				isDragging = false
		mousePos = event.position
		aim_order.emit(mousePos)
		draw_area(isDragging)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# If click, there might be a command sent.
	if Input.is_action_just_pressed("LeftClick"):
		
		# If no command is issued, behave with drag
		if command == ImpendingCommand.None:
			rectStart = mousePos
			isDragging = true
		
		# Otherwise, send the command to the Actors element to build the new things,
		# Then send the command.
		else:
			
			# Sending a signal, which the Actors object should receive.
			match command:
					ImpendingCommand.BuildTank:
						build_tank_order.emit(mousePos)
						pass
					ImpendingCommand.BuildWorker:
						build_worker_order.emit(mousePos)
						pass
					ImpendingCommand.BuildFactory:
						build_factory_order.emit(mousePos)
						pass
					ImpendingCommand.BuildPlant:
						build_plant_order.emit(mousePos)
						pass
						
			# Finally setting the order back to none
			command = ImpendingCommand.None			
	
	# If the click has been released it could be the end of a dragging!
	if Input.is_action_just_released("LeftClick") and command == ImpendingCommand.None:
		if isDragging:
			var rectangle = get_node("./Rect")
			
			# The coordinates of the rect are sent, so the game knows which area has been selected.
			area_selected.emit(
				Vector2(min(rectStart.x, mousePos.x), min(rectStart.y, mousePos.y)),
				Vector2(max(rectStart.x, mousePos.x), max(rectStart.y, mousePos.y)))
			isDragging = false
		
	# Right Click is a movement order, and a cancelling order for impending commands.
	if Input.is_action_just_pressed("RightClick"):
		movement_order.emit(get_viewport().get_mouse_position())
		
		# If a command is issued, cancelling it.
		command = ImpendingCommand.None
	pass


func _on_build_plant_pressed():
	print("Pressed Build Plant")
	command = ImpendingCommand.BuildPlant
	pass # Replace with function body.
	

func _on_build_factory_pressed():
	print("Pressed Build Factory")
	command = ImpendingCommand.BuildFactory
	pass # Replace with function body.

func _on_add_worker_pressed():
	print("Pressed Add Worker")
	command = ImpendingCommand.BuildWorker
	pass # Replace with function body.

func _on_add_tank_pressed():
	print("Pressed Add Tank")
	command = ImpendingCommand.BuildTank
	pass # Replace with function body.
