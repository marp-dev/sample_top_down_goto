extends Node

signal finished(ref)

var UP
var motion
var parent

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


func handle_input(event):
	pass


func reconnect():
	parent.handle_input.connect(handle_input)
	parent.update.connect(update)


func halt():
	parent.handle_input.disconnect(handle_input)
	parent.update.disconnect(update)


func update(delta):
	parent.set_velocity(motion)
	parent.move_and_slide()
	parent.velocity

#func _on_animation_finished(anim_name):
#	return
