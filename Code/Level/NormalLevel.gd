class_name NormalLevel extends Level

const CURRENCY_SCENE: PackedScene = preload("uid://d3np1cef23mrd")

var money: int = 500

@onready var currency_spawn_location: PathFollow2D = $CurrencyPath/CurrencySpawnLocation
@onready var currency_timer: Timer = $CurrencyTimer
@onready var default_selector: DefaultSelector = $GameInterface/DefaultSelector
@onready var plant_selector: PlantSelector = $PlantSelector

func _ready() -> void:
	Signals.add_money.connect(add_money)
	Signals.money_changed.emit(money)
	super()

func add_money(_money: int):
	money += _money
	Signals.money_changed.emit(money)

func _buy_plant(plant_to_spawn: PlantData, coordinates: Vector2) -> Plant:
	add_money(-selected_plant.cost)
	return super(plant_to_spawn, coordinates)

func select_plant(plant: PlantData, plant_scene: PackedScene, plant_index: int):
	if money < plant.cost:
		return
	
	super(plant, plant_scene, plant_index)

func _start_game() -> void:
	currency_timer.start()
	super()

func _on_currency_timer_timeout() -> void:
	var currency = CURRENCY_SCENE.instantiate()
	currency_spawn_location.set_progress_ratio(randf())
	
	currency.global_position = currency_spawn_location.global_position
	add_child(currency)

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
