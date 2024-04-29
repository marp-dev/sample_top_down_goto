extends 'state_machine_2D.gd'


var stack = []


func _input(event):
	if stack.is_empty():
		return false
	handle_input.emit(event)


func _process(delta):
	if stack.is_empty():
		return false
	update.emit(delta)


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
	
	if not nested and not stack.is_empty() and String(stack[0].name) == String(state):
		exit(String(stack[0].name))
	if not nested:
		if parent == self:
			state_node = states.get_node(state)
		else:
			state_node = self.get_node(state)
	if not state_node:
		return false
	if not stack.is_empty():
		stack[0].halt()
	stack.push_front( state_node )
	if not stack[0].finished.is_connected(on_finished):
		stack[0].finished.connect(on_finished)
	if nested:
		stack[0].enter(call_name, props)
		return
	stack[0].enter(props)


func get_path_parent(node_path):
	var names = []
	for i in range(0,node_path.get_name_count() - 1):
		names.push_back(node_path.get_name(i))
	return NodePath( '/'.join(names) )


func on_finished(state_name):
	exit(state_name)


func exit(state_name = null):
	if not stack.is_empty():
		stack[0].finished.disconnect(on_finished)
		stack[0].exit(state_name)
		stack.pop_front()
		reconnect()
	if stack.is_empty():
		if DEFAULT_STATE:
			enter()
			return
		if parent == self:
			finished.emit(name)
			return
		finished.emit(parent.get_node('states').get_path_to(self))


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
