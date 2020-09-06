extends Area2D

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group('player'):
		body.add_weapon(global.weapons.weapon.instance())
		queue_free()
