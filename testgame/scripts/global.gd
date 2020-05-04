extends Node


var states

func _ready():
	states = {}
	states.idle = preload('states/idle.gd')
	states.movement = preload('states/movement.gd')
