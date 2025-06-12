extends Area3D

const SPEED = 100.0
const RANGE = 120.0

var distance_travelled = 0.0

func _physics_process(delta: float) -> void:
	position += transform.basis.z * SPEED * delta
	distance_travelled += SPEED * delta
	
	# delete bullet from scene after exceeding range
	if distance_travelled > RANGE:
		queue_free()
	


func _on_body_entered(body: Node3D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
