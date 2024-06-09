extends 'state_machine_2D.gd'


var stack = []


func _input(event):
	if stack.is_empty():
		return false
	on_input.emit(event)


func _process(delta):
	if stack.is_empty():
		return false
	on_process.emit(delta)


func _physics_process(delta):
	if stack.is_empty():
		return false
	on_physics_process.emit(delta)


func enter(state = DEFAULT_STATE, props = {}):
	if not state:
		return
	if not parent:
		push_warning('call setup before calling enter')
		return

	var node_path = NodePath(state)
	if node_path.is_empty() or node_path.is_absolute():
		push_warning('only [non-empty] relative paths allowed in enter')
		return

	var states = parent.get_node('states')
	if not states:
		push_warning('there is no states child in state machine')
		return
	
	props['owner'] = parent
	var nested = false
	var state_node
	var call_name
	var state_parent_path
	var state_parent_node
	var name_count = node_path.get_name_count()
	if name_count > 1:
		state_parent_path = get_path_parent(node_path)
		state_parent_node = states.get_node(state_parent_path)
		if state_parent_node.has_method('enter'):
			state_node = state_parent_node
			call_name = NodePath(node_path.get_name(name_count - 1))
			state = state_parent_path
			nested = true

	if not nested:
		if parent == self:
			state_node = states.get_node(state)
		else:
			state_node = self.get_node(state)

	if not stack.is_empty():
		if nested and stack[0] == state_node:
			pass
		elif not nested and stack[0] == state_node:
			stop(String(stack[0].name))
		else:
			stack[0].halt()

	if not state_node:
		return false
	stack.push_front( state_node )
	if not stack[0].on_finished.is_connected(finished):
		stack[0].on_finished.connect(finished)
	if nested:
		stack[0].enter(call_name, props)
		return
	stack[0].enter(props)


func finished(state_name):
	exit(state_name)


func stop(state_name = null):
	if (
		not stack.is_empty() and 
		(not state_name or stack[0].name == state_name)
		):
		stack[0].on_finished.disconnect(finished)
		stack[0].exit(state_name)
		stack.pop_front()


func exit(state_name = null):
	stop(state_name)
	if not stack.is_empty():
		reconnect()
		return
	if DEFAULT_STATE:
		enter()
		return
	if parent == self:
		on_finished.emit(name)
		return
	on_finished.emit(parent.get_node('states').get_path_to(self))


func reconnect():
	if not stack.is_empty():
		stack[0].reconnect()


func halt():
	if not stack.is_empty():
		stack[0].halt()


func current_state():
	if stack.is_empty():
		return ""
	return stack[0].name


func current_states():
	if stack.is_empty():
		return []
	return [stack[0].name]
