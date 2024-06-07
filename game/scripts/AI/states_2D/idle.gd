extends 'state.gd'


var UP
var motion


# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	UP = Vector2(0,-1)
	motion = Vector2()
	motion.x = 0
	motion.y = 0


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	halt()


func process(delta):
	parent.set_velocity(motion)
	parent.move_and_slide()
	parent.velocity

