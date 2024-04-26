extends Node2D

var FIRERATE = 0.2
var BULLET_SPEED = 800
var timer
var weilder

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = FIRERATE

func fire():
	if timer.is_stopped() and timer.time_left == 0:
		$AnimationPlayer.play("muzzle")
		var direction = ($FiringPoint.global_position - global_position).normalized()
		var bullet = preload("res://scenes/Bullet.tscn").instantiate()
		add_child(bullet)
		bullet.set_as_top_level(true)
		bullet.global_position = $FiringPoint.global_position
		bullet.global_rotation = global_rotation
		bullet.set_linear_velocity(direction * BULLET_SPEED)
		bullet.add_collision_exception_with(self)
		timer.start()
