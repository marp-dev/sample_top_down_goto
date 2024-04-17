extends Node

signal finished

#var UP
var logging
var parent
var target

# Initialize the state. E.g. change the animation
func enter(props = {}):
	name = "STATE_FOLLOW"
	parent = owner
	if props['owner'] != null:
		parent = props['owner']
	if props['target'] != null:
		target = parent.get_node(props['target'])

# Clean up the state. Reinitialize values like a timer
func exit():
	pass

func handle_input(event):
	pass

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
