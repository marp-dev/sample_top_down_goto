extends Node


signal on_finished(ref)

var parent


func reconnect():
	parent.on_input.connect(input)
	parent.on_process.connect(process)
	parent.on_physics_process.connect(physics_process)


func halt():
	parent.on_input.disconnect(input)
	parent.on_process.disconnect(process)
	parent.on_physics_process.disconnect(physics_process)


func input(event):
	pass


func process(delta):
	pass


func physics_process(delta):
	pass
