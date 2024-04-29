extends 'AI/parallel_state_machine_2D.gd'


@onready var logging = ""
@onready var current_weapon = null
var SPEED = 17000
@export var follow_to: NodePath


func _ready():
	DEFAULT_STATE = 'STATE_IDLE'
	setup()
	enter()
	add_to_group("character")

	if follow_to:
		enter('STATE_FOLLOW', { "target": follow_to})
	
	if not global.DEBUG:
		$Logging/Label.hide()


func _process(delta):
	if not state_list.is_empty():
		logging += "state: " + current_state() + "\n"
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
	enter('MOVEMENT/STATE_FOLLOW', { "target": follow_to})

func go_to(target, obj = false, method = false):
	enter('MOVEMENT/STATE_GOTO', { "target": target})


func fire():
	if current_weapon != null:
		enter('STATE_FIRE')
