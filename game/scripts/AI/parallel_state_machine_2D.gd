extends 'state_machine_2D.gd'


var state_list = {}


func _input(event):
	if state_list.is_empty():
		return false
	on_input.emit(event)


func _process(delta):
	if state_list.is_empty():
		return false
	on_process.emit(delta)


func enter(state = DEFAULT_STATE, props = {}):
	if not state:
		return
	if not parent:
		push_warning('call setup before calling enter')
		return
	var states = parent.get_node('states')
	if not states:
		push_warning('there is no states child in state machine')
		return
	if state_list.has(state) and state_list[state].name == state:
		return
	
	var node_path = NodePath(state)
	if node_path.is_empty() or node_path.is_absolute():
		push_warning('only [non-empty] relative paths allowed in enter')
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
			state_node = states.get_node(node_path)
		else:
			state_node = self.get_node(node_path)
	if not state_node:
		push_warning('state %s not found' % state)
		return false
	state_list[state] = state_node
	if not state_list[state].on_finished.is_connected(finished):
		state_list[state].on_finished.connect(finished)
	if nested:
		state_list[state].enter(call_name, props)
		return
	state_list[state].enter(props)


func finished(state_name):
	exit(state_name)


func stop(state_name):
	if state_list.has(state_name):
		state_list[state_name].on_finished.disconnect(finished)
		state_list[state_name].exit()
		state_list.erase(state_name)


func exit(state_name):
	stop(state_name)
	if state_list.is_empty():
		if DEFAULT_STATE:
			enter()
			return
		if parent == self:
			on_finished.emit(name)
			return
		on_finished.emit(parent.get_node('states').get_path_to(self))


func reconnect():
	for state in state_list:
		state_list[state].reconnect()


func halt():
	for state in state_list:
		state_list[state].halt()


func current_state():
	if state_list.is_empty():
		return ""
	return ",".join(current_states())


func current_states():
	var current = []
	var states = parent.get_node('states')
	for key in state_list.keys():
		var state_name = String(key)
		if states.is_ancestor_of(state_list[key]) and state_list[key].has_method('current_state'):
			state_name = String(key) + "/" + String(state_list[key].current_state()) 
		current.push_back(state_name)
	return current

