## Base class representing a status effect.
class_name StatusEffect extends Node

@onready var duration: Timer = $Duration

## The status effect this node applies. Every status effect can only exist 
## once on a given [Enemy], and this is decided on the basis of this ID.[br][br]
## [b]Note:[/b][br] 
## Setting this doesn't change the behavior of the node, but makes 
## it so that it extends the duration of any status effects with the same ID.
@export var ID: Enums.STATUS_EFFECTS = Enums.STATUS_EFFECTS.NONE
## The base duration for which this effect will last.
@export var duration_time: float = 10

## Enemy to which the status effect is applied
var enemy: Enemy

## Emitted when the status effect is applied (but not extended).
signal applied
## Emitted when the duration of the status effect is extended.
signal duration_extended
## Emitted when the status effect expires.
signal expired

func _ready() -> void:
	duration.wait_time = duration_time

func _process(_delta: float):
	pass

## Applies the status effect to the provided [Enemy]. 
## Returns true if the effect didn't exist on the enemy. Calls 
## [method extend_duration], returns false and deletes itself if it did.[br][br]
## [b]Params:[/b][br]
## [param _enemy] - [Enemy] to which it is being applied.[br][br]
## [b]Returns:[/b][br]
## [b]true[/b] - If the effect was applied.[br]
## [b]false[/b] - If the effect was extended.[br]
func apply(_enemy: Enemy) -> bool:
	enemy = _enemy
	
	for status_effect: StatusEffect in enemy.status_effects_holder.get_children():
		# we don't care for different status effects
		if status_effect.ID != ID:
			continue
		# we extend our own status effect
		if status_effect.ID == ID:
			status_effect.extend_duration()
			queue_free()
			return false
	
	# our status effect does not exist on the target yet, apply it
	enemy.status_effects.append(self)
	reparent(enemy)
	applied.emit()
	duration.wait_time = duration_time
	duration.start()
	return true

## resets the duration of the status effect
func extend_duration() -> void:
	duration_extended.emit()
	duration.start()

func _on_duration_timeout() -> void:
	expired.emit()
	queue_free()
