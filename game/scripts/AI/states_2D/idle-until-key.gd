extends 'state.gd'


var UP
var motion


# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	halt()


func input(event):
	if Input.is_anything_pressed():
		on_finished.emit(name)


func process(delta):
	pass

