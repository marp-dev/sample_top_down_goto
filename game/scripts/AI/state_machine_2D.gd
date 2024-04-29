extends CharacterBody2D


signal update(delta)
signal handle_input(event)
signal finished(ref)

var DEFAULT_STATE = null
var parent


func _ready():
	add_to_group('state_machine')


func setup(instance = null):
	parent = instance if instance else self
	var states = parent.get_node('states')
	if not states:
		push_warning('there is no states child in state machine')
		return
	if instance:
		return
	for node in states.get_tree().get_nodes_in_group("state_machine"):
		if states.is_ancestor_of(node):
			node.setup(parent)
