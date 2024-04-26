extends Node

signal finished(ref)

#var UP
var logging
var parent
var target

# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	if props['target'] != null:
		target = parent.get_node(props['target'])

# Clean up the state. Reinitialize values like a timer
func exit():
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
	if target:
		var direction = (target.global_position - parent.global_position).normalized()
		var distance = parent.global_position.distance_to(target.global_position)
		var motion = direction * parent.SPEED * delta
		if distance < 5:
			motion *= ((distance - 2) / 3)
		parent.set_velocity( motion )
		parent.move_and_slide()

#func _on_animation_finished(anim_name):
#	return
