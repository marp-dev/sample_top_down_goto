extends Node

signal finished(ref)

#var UP
var motion
var logging
var parent

# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = owner
	if props['owner']:
		parent = props['owner']
	#UP = Vector2(0,-1)
	motion = Vector2()
	motion.x = 0
	motion.y = 0

# Clean up the state. Reinitialize values like a timer
func exit():
	pass

func handle_input(event):
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

func update(delta):
	parent.set_velocity(motion * delta)
	parent.move_and_slide()
	#parent.velocity

#func _on_animation_finished(anim_name):
#	return
