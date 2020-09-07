extends Area2D

var picker

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group('player'):
		body.add_weapon(global.weapons.weapon.instance())
		queue_free()
	if body.is_in_group('formation'):
		picker = body.get_weapon(self)

func pick():
	return global.weapons.weapon.instance()
