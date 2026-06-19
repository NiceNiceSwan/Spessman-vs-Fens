class_name Slowdown extends StatusEffect

func apply(_enemy: Enemy) -> bool:
	var applied: bool = super(_enemy)
	if applied:
		enemy.move_speed_modifier = 0.8
	
	return applied

func _on_duration_timeout():
	super()
	enemy.move_speed_modifier = 1
