extends RigidBody2D

var firedby


func _ready():
	connect('body_entered', self, 'collision_handler')


func collision_handler(body):
	queue_free()
