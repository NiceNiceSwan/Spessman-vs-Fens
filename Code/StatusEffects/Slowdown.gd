class_name Slowdown extends StatusEffect

func apply(_enemy: Enemy) -> bool:
	var has_applied: bool = super(_enemy)
	if has_applied:
		enemy.move_speed_modifier = 0.7
	
	return has_applied

func _on_duration_timeout():
	super()
	enemy.move_speed_modifier = 1
