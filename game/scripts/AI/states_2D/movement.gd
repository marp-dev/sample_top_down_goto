extends 'state.gd'


#var UP
var motion
var logging



# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	motion = Vector2()
	motion.x = 0
	motion.y = 0


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	halt()


func input(event):
	if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
		motion.x = 0
	elif Input.is_action_pressed("ui_left"):
		motion.x = -1 * parent.SPEED
	elif Input.is_action_pressed("ui_right"):
		motion.x = 1 * parent.SPEED
	else:
		motion.x = 0
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		motion.y = 0
	elif Input.is_action_pressed("ui_up"):
		motion.y = -1 * parent.SPEED
	elif Input.is_action_pressed("ui_down"):
		motion.y = 1 * parent.SPEED
	else:
		motion.y = 0
	if motion.x == 0 and motion.y == 0:
		on_finished.emit(name)


func process(delta):
	parent.set_velocity(motion * delta)
	parent.move_and_slide()

