extends 'state_machine.gd'

onready var logging = ""
var label

func _ready():
	._ready()
	label = $Label
	states.movement = global.states.movement.new()

func _input(event):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		state_change("movement")
	else:
		state_change("idle")
	._input(event)

func _process(delta):
	logging += "state: " + current_state.name + "\n"
	look_at(get_global_mouse_position())
	._process(delta)
	label.text = logging
	logging = ""
