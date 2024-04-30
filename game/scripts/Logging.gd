extends Node2D


var offset_position:Vector2
@export var text:String


func _ready():
	visible = true
	text = ""
	if not offset_position:
		offset_position = Vector2(100,-100)


func _process(delta):
	if get_parent().global_position:
		global_position = get_parent().global_position + offset_position
	global_rotation_degrees = 0.0
	$Label.text = text
	text = ""

func get_text():
	return text
