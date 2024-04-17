extends 'AI/state_machine_2D.gd'

@onready var logging = ""
@onready var current_weapon = null
var SPEED = 17000
@export var follow_to: NodePath

var goto_call_obj
var goto_call_method

func _ready():
	super._ready()
	add_to_group("character")

	if follow_to:
		state_change(STATE_FOLLOW, { "target": follow_to})
	
	if not global.DEBUG:
		$Logging/Label.hide()

func _process(delta):
	logging += "state: " + stack[0].name + "\n"
	look_at(get_global_mouse_position())
	super._process(delta)
	$Logging/Label.text = logging
	logging = ""
	$Logging.global_rotation_degrees = 0.0


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


func has_weapon():
	return current_weapon != null


func follow(target):
	if(typeof(target) == TYPE_NODE_PATH):
		follow_to = target
	elif(typeof(target) == TYPE_OBJECT):
		follow_to = target.get_path()
	state_change(STATE_FOLLOW, { "target": follow_to})

func go_to(target, obj = false, method = false):
	if current_state() == STATE_GOTO:
		eject_state()
	state_change(STATE_GOTO, { "target": target})
	if obj and method:
		goto_call_obj = obj
		goto_call_method = method


func on_finished(state_name):
	if state_name == STATE_GOTO:
		if goto_call_obj and goto_call_obj.has_method(goto_call_method):
			goto_call_obj.call(goto_call_method)
	super.on_finished(state_name)


func fire():
	if current_weapon != null:
		current_weapon.fire()
