extends RigidBody2D


var firedby


func _ready():
	connect('body_entered', Callable(self, 'collision_handler'))


func collision_handler(body):
	queue_free()

