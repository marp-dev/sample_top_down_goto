extends 'state.gd'


#var UP
var logging
var target


# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	if props['target'] != null:
		target = parent.get_node(props['target'])


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	halt()


func input(event):
	pass


func process(delta):
	if target:
		var direction = (target.global_position - parent.global_position).normalized()
		var distance = parent.global_position.distance_to(target.global_position)
		var motion = direction * parent.SPEED * delta
		if distance < 5:
			motion *= ((distance - 2) / 3)
		parent.set_velocity( motion )
		parent.move_and_slide()

