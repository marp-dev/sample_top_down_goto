extends Area2D

var picker
var weapon

func _ready():
	weapon = global.weapons.weapon
	connect("body_entered", Callable(self, "on_body_entered"))

func on_body_entered(body):
	#print("on_body_entered")
	#var groups = PackedStringArray(body.get_groups())
	#print("body {name} is in groups {groups}".format({"name":body.name, "groups":",".join(groups)}) )
	if body.is_in_group('player') or picker == body:
		#print("picker")
		body.add_weapon(weapon.instantiate())
		queue_free()
	if body.is_in_group('formation'):
		#print("formation")
		picker = body.get_weapon(self)

func pick():
	return global.weapons.weapon.instantiate()
