class_name Freeze extends StatusEffect

func apply(_enemy: Enemy) -> bool:
	var has_applied: bool = super(_enemy)
	if has_applied:
		enemy.move_speed_modifier = 0.0
		enemy.attack_speed_modifier = 99999999
	
	return has_applied

func _on_duration_timeout() -> void:
	super()
	enemy.move_speed_modifier = 1
	enemy.attack_speed_modifier = 1
