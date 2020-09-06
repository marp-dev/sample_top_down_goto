extends 'state_machine.gd'

var current_rotation
var in_range
onready var range_limit = PI/9
onready var inrange_step = PI/90
onready var offrange_step = PI/45
var step

var label_position

func _ready():
	._ready()
	states.movement = global.states.movement.new()
	current_rotation = global_rotation
	$positions.global_rotation = current_rotation
	$Label.text = ""
	label_position = $Label.rect_position
	in_range = true
	add_to_group('formation')

func _input(event):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		state_change("movement")
	else:
		state_change("idle")
	._input(event)

func _process(delta):
	look_at(get_global_mouse_position())
	$Label.text = ""
	$Label.set_global_position(global_position + label_position)
	$Label.rect_rotation = -1 * rad2deg(global_rotation)
	check_range()
	if in_range:
		step = inrange_step
	else:
		step = offrange_step

	$Label.text += "global:" + String(global_rotation) + "\n"
	$Label.text += "current: " + String(current_rotation) + "\n"
	rotate_formation()
	._process(delta)

func check_range():
	if global_rotation > (current_rotation - range_limit) and global_rotation < (current_rotation + range_limit):
		in_range = true
	else:
		in_range = false

func rotate_formation():
	var rotation_diff
	if (current_rotation > 0 and global_rotation > 0) or (current_rotation < 0 and global_rotation < 0):
		rotation_diff = current_rotation - global_rotation
		current_rotation += clamp((-1 * rotation_diff), -step, step)
		$positions.global_rotation = current_rotation
		return
	
	if current_rotation == 0:
		current_rotation += clamp(global_rotation, -step, step)
		$positions.global_rotation = current_rotation
		return
	
	var to0 = abs(current_rotation) + abs(global_rotation)
	var toPI = (PI - abs(current_rotation)) + (PI - abs(global_rotation)) 
	
	if to0 < toPI:
		current_rotation += clamp((-1 * current_rotation), -step, step)
	
	if toPI < to0:
		current_rotation = clamp( current_rotation + clamp(current_rotation, -step, step) , -PI, PI)
		if current_rotation == PI or current_rotation == -PI:
			current_rotation = -current_rotation

	$positions.global_rotation = current_rotation
	
	#$Label.text += "diff:" + String(rotation_diff) + "\n  current: " + String(current_rotation) +  "\n   global:" + String(global_rotation) + ")\n"
	#$Label.text += "-diff:" + String(abs(rotation_diff) - (PI*2)) + "\n"

func add_weapon(weapon):
	pass

#func _process_characters():
#	for child in get_children():
#		if child.is_in_group('character'):
#			pass
