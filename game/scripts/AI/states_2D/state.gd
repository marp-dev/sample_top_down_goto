extends Node


signal on_finished(ref)

var parent


func reconnect():
	parent.on_input.connect(input)
	parent.on_process.connect(process)


func halt():
	parent.on_input.disconnect(input)
	parent.on_process.disconnect(process)


func input(event):
	pass


func process(delta):
	pass

