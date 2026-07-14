class_name EnemyPreview extends Area2D

const MAXIMUM_ENEMIES_OF_TYPE_SHOWN = 4

@onready var enemy_preview_shape: CollisionShape2D = $EnemyPreviewShape

func spawn_enemy_preview(enemies_data: Dictionary[EnemyResource, int]):
	var center_position: Vector2 = enemy_preview_shape.position
	var area_size: Vector2 = enemy_preview_shape.shape.size
	var position_in_area: Vector2 = Vector2(0, 0)
	for enemy_resource: EnemyResource in enemies_data:
		var enemies_shown: int = min(enemies_data[enemy_resource] / 10, MAXIMUM_ENEMIES_OF_TYPE_SHOWN)
		for index in range(enemies_shown):
			position_in_area.x = (randi() % int(area_size.x)) - (area_size.x / 2) + center_position.x
			position_in_area.y = (randi() % int(area_size.y)) - (area_size.y / 2) + center_position.y
			var new_object: Sprite2D = Sprite2D.new()
			new_object.texture = enemy_resource.texture
			new_object.position = position_in_area
			add_child(new_object)
