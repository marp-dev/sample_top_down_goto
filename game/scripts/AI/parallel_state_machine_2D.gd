extends CharacterBody2D

signal update(delta)
signal handle_input(event)

var DEFAULT_STATE = null
var state_list = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	enter()


func _input(event):
	if state_list.is_empty():
		return false
	handle_input.emit(event)


func _process(delta):
	if state_list.is_empty():
		return false
	update.emit(delta)


func enter(state = DEFAULT_STATE, props = {}):
	if not state:
		return
	if not $states:
		push_warning('there is no states child in state machine')
		return
	if state_list.has(state) and state_list[state].name == state:
		return
	var state_node = $states.get_node(state)
	if not state_node:
		return false
	state_list[state] = state_node
	state_list[state].finished.connect(on_finished)
	props['owner'] = self
	state_list[state].enter(props)


func on_finished(state_name):
	exit(state_name)


func exit(state_name):
	if state_list.has(state_name):
		state_list[state_name].finished.disconnect(on_finished)
		state_list[state_name].exit()
		state_list.erase(state_name)
	if state_list.is_empty():
		enter()


func current_state():
	if state_list.is_empty():
		return ""
	return ",".join(current_states())


func current_states():
	return state_list.keys()
