extends 'state.gd'


#var UP
var logging
@onready var target = null
@onready var invalid = false


# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	if typeof(props['target']) == TYPE_NODE_PATH:
		target = parent.get_node(props['target'])
	elif typeof(props['target']) == TYPE_OBJECT:
		target = props['target']
	else:
		invalid = true
	if not parent.navigation_agent.velocity_computed.is_connected(on_velocity_computed):
		parent.navigation_agent.velocity_computed.connect(on_velocity_computed)
	parent.navigation_agent.set_target_position(target.global_position)


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	if parent.navigation_agent.velocity_computed.is_connected(on_velocity_computed):
		parent.navigation_agent.velocity_computed.disconnect(on_velocity_computed)
	halt()


func input(event):
	pass


func physics_process(delta):
	if invalid:
		push_warning('invalid follow target')
		return false;

	if parent.navigation_agent.is_navigation_finished():
		parent.navigation_agent.set_target_position(target.global_position)
		return

	if target:
		var next_path_position = parent.navigation_agent.get_next_path_position()
		var direction = (next_path_position - parent.global_position).normalized()
		var distance = parent.global_position.distance_to(next_path_position)
		var motion = direction * parent.SPEED * delta
		if distance < 5:
			motion *= ((distance - 2) / 3)
		if parent.navigation_agent.avoidance_enabled:
			parent.navigation_agent.set_velocity(motion)
		else:
			on_velocity_computed(motion)


func on_velocity_computed(safe_velocity: Vector2):
	parent.set_velocity(safe_velocity)
	parent.move_and_slide()

