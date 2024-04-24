extends CharacterBody2D

var DEFAULT_STATE = null
var stack = []


# Called when the node enters the scene tree for the first time.
func _ready():
	state()


func _input(event):
	if stack.is_empty():
		return false
	stack[0].handle_input(event)


func _process(delta):
	if stack.is_empty():
		return false
	stack[0].update(delta)


func state(state = DEFAULT_STATE, props = {}):
	if not state:
		return
	if not $states:
		push_warning('there is no states child in state machine')
		return
	var state_node = $states.get_node(state)
	if not state_node:
		return false
	stack.push_front( state_node )
	stack[0].finished.connect(on_finished)
	props['owner'] = self
	stack[0].enter(props)


func on_finished(state_name):
	eject_state()


func eject_state():
	if not stack.is_empty():
		stack[0].finished.disconnect(on_finished)
		stack[0].exit()
		stack.pop_front()


func current_state():
	if stack.is_empty():
		return ""
	return stack[0].name
