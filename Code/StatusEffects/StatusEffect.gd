class_name StatusEffect extends Node

@onready var duration: Timer = $Duration
@onready var tick_timer: Timer = $TickTimer

@export var ID: Enums.STATUS_EFFECTS = Enums.STATUS_EFFECTS.NONE

## Enemy to which the status effect is applied
var enemy: Enemy
var already_applied: bool = false

signal applied
signal duration_extended
signal expired

## returns true if it was applied
## returns false if it wasn't
func apply(_enemy: Enemy) -> bool:
	enemy = _enemy
	
	for status_effect: StatusEffect in enemy.status_effects_holder.get_children():
		if status_effect.ID != ID:
			continue
		if status_effect.ID == ID:
			status_effect.extend_duration()
			queue_free()
			return false
	
	enemy.status_effects.append(self)
	reparent(enemy)
	applied.emit()
	duration.start()
	return true

func _process(delta: float):
	pass

func extend_duration():
	duration_extended.emit()
	duration.start()

func _on_duration_timeout():
	expired.emit()
	queue_free()

func _on_tick_timer_timeout():
	pass
