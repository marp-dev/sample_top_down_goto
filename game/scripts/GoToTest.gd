extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var marker = null

# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


func _input(event):
	if Input.is_action_just_pressed("ui_fire"):
		var mouse_position = get_global_mouse_position()
		$Character.go_to( mouse_position )
		remove_marker()
		marker = load("res://scenes/TestMarker.tscn").instantiate()
		add_child(marker)
		marker.global_position = mouse_position
		marker.connect("body_entered", Callable(self, "remove_marker"))

func remove_marker(body = null):
	if marker != null:
		marker.remove()
		marker = null
