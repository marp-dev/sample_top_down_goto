extends 'state_machine.gd'

func _ready():
	._ready()
	states.movement = global.states.movement.new()

func _input(event):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		state_change("movement")
	else:
		state_change("idle")
	._input(event)

func _process(delta):
	look_at(get_global_mouse_position())
	._process(delta)
