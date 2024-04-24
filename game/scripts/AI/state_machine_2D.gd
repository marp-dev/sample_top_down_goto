extends CharacterBody2D

var states_path = {
	"STATE_IDLE": preload("states_2D/idle.gd"),
	"STATE_GOTO": preload("states_2D/go_to.gd"),
	"STATE_FOLLOW": preload("states_2D/follow.gd"),
	"STATE_MOVEMENT": preload("states_2D/movement.gd"),
}
const STATE_IDLE = "STATE_IDLE"
const STATE_GOTO = "STATE_GOTO"
const STATE_FOLLOW = "STATE_FOLLOW"
const STATE_MOVEMENT = "STATE_MOVEMENT"
var stack = []


# Called when the node enters the scene tree for the first time.
func _ready():
	state_change()


func _input(event):
	stack[0].handle_input(event)


func _process(delta):
	stack[0].update(delta)


func state_change(state = STATE_IDLE, props = {}):
	stack.push_front( states_path[state].new() )
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
	return stack[0].name
