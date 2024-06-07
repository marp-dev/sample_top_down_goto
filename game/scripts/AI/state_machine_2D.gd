extends CharacterBody2D


signal on_process(delta)
signal on_input(event)
signal on_finished(ref)

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


func get_path_parent(node_path):
	var states = parent.get_node('states')
	var child_state = states.get_node(node_path)
	return states.get_path_to(child_state.get_parent())

