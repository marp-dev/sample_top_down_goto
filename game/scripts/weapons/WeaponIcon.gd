extends Area2D

var picker
var weapon

func _ready():
	weapon = global.weapons.weapon
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.is_in_group('player') or picker == body:
		body.add_weapon(weapon.instance())
		queue_free()
	if body.is_in_group('formation'):
		picker = body.get_weapon(self)

func pick():
	return global.weapons.weapon.instance()
