extends Node


var states
var weapons
var pointer

func _ready():
	states = {}
	states.idle = preload('states/idle.gd')
	states.movement = preload('states/movement.gd')
	states.follow = preload('states/follow.gd')
	
	weapons = {}
	weapons.weapon = preload('../scenes/weapon.tscn')

	
