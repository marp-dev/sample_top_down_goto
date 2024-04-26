extends 'AI/parallel_state_machine_2D.gd'

@onready var logging = ""
@onready var label = $Logging/Label
var SPEED = 17000
var current_weapon

func _ready():
	DEFAULT_STATE = 'STATE_IDLE'
	super._ready()
	add_to_group("player")

func _input(event):
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		enter('STATE_MOVEMENT')

	if current_weapon and Input.is_action_just_pressed("ui_fire"):
		enter('STATE_FIRE')
	super._input(event)

func _process(delta):
	if not state_list.is_empty():
		logging += "state: " + current_state() + "\n"
	look_at(get_global_mouse_position())
	super._process(delta)
	$Logging.global_rotation_degrees = 0.0
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
