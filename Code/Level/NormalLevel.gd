class_name NormalLevel extends Level

@onready var default_selector: DefaultSelector = $GameInterface/DefaultSelector
@onready var plant_selector: PlantSelector = $PlantSelector

func _ready() -> void:
	super()

func select_plant(plant: PlantData, plant_scene: PackedScene, plant_index: int):
	if money < plant.cost:
		return
	
	super(plant, plant_scene, plant_index)

func _on_plant_selector_play_button_pressed(selected_plants: Array[PlantSelectButton]) -> void:
	player_camera.set_target(Vector2(0, 0))
	default_selector.load_plant_data(selected_plants)
	plant_selector.queue_free()
	plants_selected = true

func _on_player_camera_reached_target() -> void:
	if not plants_selected:
		plant_selector.slide_panels_in()
		return
	_start_game()
