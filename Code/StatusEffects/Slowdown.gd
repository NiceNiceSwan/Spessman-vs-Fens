class_name Slowdown extends StatusEffect

func apply(_enemy: Enemy) -> bool:
	var has_applied: bool = super(_enemy)
	if has_applied:
		enemy.move_speed_modifier = 0.5
		enemy.attack_speed_modifier = 2
		enemy.sprite.set_modulate(Color(0.063, 0.235, 0.843, 1.0))
	
	return has_applied

func _on_duration_timeout() -> void:
	super()
	enemy.move_speed_modifier = 1
	enemy.attack_speed_modifier = 1
	enemy.sprite.set_modulate(Color(1.0, 1.0, 1.0, 1.0))
