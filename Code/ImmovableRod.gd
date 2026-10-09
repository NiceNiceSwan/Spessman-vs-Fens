# yes, IRL wise it makes no sense for immovable rod to inherit from cleanbot
# however, implementation wise, it very much makes!
class_name ImmovableRod extends cleanbot

func _process(delta: float) -> void:
	var enemy: Enemy
	
	# make it so we collide with the enemy that we encounter this tick
	detection_ray.target_position.x = max(delta * speed, 32)
	
	if detection_ray.is_colliding():
		if is_instance_valid(detection_ray.get_collider()):
			var detected_area: Area2D = detection_ray.get_collider()
			enemy = detected_area.get_parent()
	
	if enemy:
		enemy.die()
	
	position += Vector2(speed, 0) * delta
	if position.x > 2000:
		queue_free()
