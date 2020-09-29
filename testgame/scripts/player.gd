extends 'AI/state_machine_2D.gd'

onready var logging = ""
var label
var current_weapon

func _ready():
	._ready()
	label = $Label
	states.movement = global.states.movement.new()
	add_to_group("player")

func _input(event):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		state_change("movement")
	else:
		state_change("idle")
	if current_weapon and Input.is_action_pressed("ui_fire"):
		current_weapon.fire()
	._input(event)

func _process(delta):
	logging += "state: " + current_state.name + "\n"
	look_at(get_global_mouse_position())
	._process(delta)
	label.text = logging
	logging = ""

func add_weapon(weapon):
	if not weapon.is_in_group('weapon'):
		weapon.queue_free()
		return false
	current_weapon = weapon
	current_weapon.weilder = self
	$weapons.add_child(current_weapon)
	current_weapon.position = $RHandHold.position
	current_weapon.rotation = 0
	#weapon.look_at(($RHandHold.position + Vector2(-1, -1)).normalized())
	return true
