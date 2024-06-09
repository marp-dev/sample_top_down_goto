extends 'state.gd'


var UP
var motion
var target_node
var target
var invalid = false

# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	if typeof(props['target']) == TYPE_NODE_PATH:
		target_node = parent.get_node(props['target'])
		target = target_node.global_position
	elif typeof(props['target']) == TYPE_VECTOR2:
		target_node = null
		target = props['target']
	elif typeof(props['target']) == TYPE_OBJECT:
		target_node = props['target']
		target = target_node.global_position
	else:
		invalid = true
	motion = Vector2()
	motion.x = 0
	motion.y = 0
	if not parent.navigation_agent.velocity_computed.is_connected(on_velocity_computed):
		parent.navigation_agent.velocity_computed.connect(on_velocity_computed)
	parent.navigation_agent.set_target_position(target)


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	if parent.navigation_agent.velocity_computed.is_connected(on_velocity_computed):
		parent.navigation_agent.velocity_computed.disconnect(on_velocity_computed)
	halt()


func physics_process(delta):
	if invalid:
		push_warning('invalid goto target')
		return false;
	
	if parent.navigation_agent.is_navigation_finished():
		on_finished.emit(name)
		return
	
	var next_path_position = parent.navigation_agent.get_next_path_position()
	var direction = (next_path_position - parent.global_position).normalized()
	var motion = direction * parent.SPEED * delta
	if parent.navigation_agent.avoidance_enabled:
		parent.navigation_agent.set_velocity(motion)
	else:
		on_velocity_computed(motion)


func on_velocity_computed(safe_velocity: Vector2):
	parent.set_velocity(safe_velocity)
	parent.move_and_slide()

