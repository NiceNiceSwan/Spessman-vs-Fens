class_name ConveyorSelector extends Control

@onready var conveyor_start: Marker2D = $ConveyorStart
@onready var conveyor_end: Marker2D = $ConveyorEnd

const MOVE_SPEED: float = 80

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for buy_button: PlantHolder in conveyor_start.get_children():
		var speed: float = MOVE_SPEED * delta
		var target_position: Vector2 = conveyor_end.position
		var index = buy_button.get_index()
		target_position.x += 32 * index
		buy_button.global_position = buy_button.global_position.move_toward(target_position, speed)

func _on_button_spawn_timer_timeout() -> void:
	pass
