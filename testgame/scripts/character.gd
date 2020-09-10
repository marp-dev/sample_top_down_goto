extends 'state_machine.gd'

onready var logging = ""
var label
var current_weapon
var SPEED = 100
export(NodePath) var follow_to

func _ready():
	._ready()
	label = $Label
	states.follow = global.states.follow.new()
	add_to_group("character")

	if follow_to:
		state_change('follow', { "target": follow_to})

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

func follow(target):
	if(typeof(target) == TYPE_NODE_PATH):
		follow_to = target
	elif(typeof(target) == TYPE_OBJECT):
		follow_to = target.get_path()
	state_change('follow', { "target": follow_to})
