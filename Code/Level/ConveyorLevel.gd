class_name ConveyorLevel extends Level

@onready var conveyor_selector: ConveyorSelector = $GameInterface/ConveyorSelector
@onready var enemy_showcase_trailer: Timer = $EnemyShowcaseTrailer

func _on_enemy_showcase_trailer_timeout() -> void:
	player_camera.set_target(Vector2(0, 0))
	plants_selected = true

func _on_player_camera_reached_target() -> void:
	if not plants_selected:
		enemy_showcase_trailer.start()
		return
	_start_game()
