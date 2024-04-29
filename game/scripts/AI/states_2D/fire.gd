extends Node

signal finished(ref)

#var UP
var motion
var logging
var parent
var timer
var weapon
var bullet
var direction


func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true


# Initialize the state. E.g. change the animation
func enter(props = {}):
	parent = props['owner'] if props.has('owner') else owner
	reconnect()
	motion = Vector2()
	motion.x = 0
	motion.y = 0
	weapon = parent.current_weapon if parent.current_weapon else null


# Clean up the state. Reinitialize values like a timer
func exit(state_name = null):
	halt()
	#timer.free()
	motion = null
	direction = null
	parent = null
	weapon = null


func reconnect():
	parent.handle_input.connect(handle_input)
	parent.update.connect(update)


func halt():
	parent.handle_input.disconnect(handle_input)
	parent.update.disconnect(update)


func handle_input(event):
	#if Input.is_action_pressed("ui_fire"):
	#	fire()
	if Input.is_action_just_released("ui_fire"):
		finished.emit(name)


func fire():
	if not weapon:
		return
	if timer.is_stopped() and timer.time_left == 0:
		weapon.get_node('AnimationPlayer').play("muzzle")
		direction = (weapon.get_node('FiringPoint').global_position - weapon.global_position).normalized()
		bullet = preload("res://scenes/Bullet.tscn").instantiate()
		add_child(bullet)
		bullet.set_as_top_level(true)
		bullet.add_to_group('bullet')
		bullet.global_position = weapon.get_node('FiringPoint').global_position
		bullet.global_rotation = weapon.global_rotation
		#bullet.add_collision_exception_with(self)
		bullet.set_linear_velocity(direction * weapon.BULLET_SPEED)
		timer.start(weapon.FIRERATE)
		return


func update(delta):
	fire()

