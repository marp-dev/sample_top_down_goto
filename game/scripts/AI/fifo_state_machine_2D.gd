extends CharacterBody2D


signal update(delta)
signal handle_input(event)

var DEFAULT_STATE = null
var stack = []


# Called when the node enters the scene tree for the first time.
func _ready():
	enter()


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
	if not $states:
		push_warning('there is no states child in state machine')
		return
	if not stack.is_empty() and stack[0].name == state:
		return
	var state_node = $states.get_node(state)
	if not state_node:
		return false
	if not stack.is_empty():
		stack[0].halt()
	stack.push_front( state_node )
	stack[0].finished.connect(on_finished)
	props['owner'] = self
	stack[0].enter(props)


func on_finished(state_name):
	exit()


func exit():
	if not stack.is_empty():
		stack[0].finished.disconnect(on_finished)
		stack[0].exit()
		stack.pop_front()
		reconnect()
	if stack.is_empty():
		enter()


func reconnect():
	if not stack.is_empty():
		stack[0].reconnect()


func current_state():
	if stack.is_empty():
		return ""
	return stack[0].name
