extends Node2D


signal log_all(text, ref)
@onready var marker = null


# Called when the node enters the scene tree for the first time.
func _ready():
	if not global.DEBUG:
		return
	var logging = preload("res://scenes/Logging.tscn")
	for unit in [$Character]:
		var logger = logging.instantiate()
		unit.add_child(logger)
		logger.offset_position = Vector2(80,-80)
		var log_text_call = func(text, ref):
			log_text(text, ref)
		log_all.connect(log_text_call.bind(logger))


func log_text(text, ref):
	ref.text += text


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


func _process(delta):
	if not global.DEBUG:
		return
	$Character.get_node('Logging').text += 'states:\n'
	for state in $Character.current_states():
		$Character.get_node('Logging').text += "- %s\n" % state

