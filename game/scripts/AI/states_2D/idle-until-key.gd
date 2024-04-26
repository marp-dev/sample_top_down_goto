extends Node

signal finished(ref)

var UP
var motion
var parent


# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()


# Clean up the state. Reinitialize values like a timer
func exit():
	halt()


func handle_input(event):
	if Input.is_anything_pressed():
		finished.emit(name)


func reconnect():
	parent.handle_input.connect(handle_input)
	parent.update.connect(update)


func halt():
	parent.handle_input.disconnect(handle_input)
	parent.update.disconnect(update)


func update(delta):
	pass

