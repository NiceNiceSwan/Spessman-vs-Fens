class_name IceShroom extends Plant

@onready var freeze_all: FreezeAll = $FreezeAll

func _on_freeze_all_freezed() -> void:
	queue_free()
