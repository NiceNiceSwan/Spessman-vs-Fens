class_name level extends Node2D

var money: int = 5000

const ENEMY_WAVE_THRESHOLD = 15
const ENEMY_WAVE_AMOUNT = 75

@export var currency_scene: PackedScene
var selected_plant: PlantData
var can_place_plant: bool = false
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
var enemies_spawned: int = 0
var spawn_wave: bool = false
var wave_enemy_counter: int = 0
var wave_tick_counter: int = 0

var plant_grid: Array[Array]

func _ready():
	plant_grid.resize(9)
	for i in 9:
		plant_grid[i].resize(5)
	$LevelUI.update_money(money)

func _normalise_mouse_position_to_grid(mouse_position: Vector2) -> Vector2:
	mouse_position.x += 64
	mouse_position.y += 64
	mouse_position.x -= (int(mouse_position.x) % 128)
	mouse_position.y -= (int(mouse_position.y) % 128)
	return mouse_position

func _process(delta):
	if spawn_wave:
		_handle_wave()
	
	if Input.is_action_just_pressed("alt_click"):
		_handle_alt_click()
	
	if Input.is_action_just_pressed("click"):
		_handle_click()

func _buy_plant(plant_to_spawn: PlantData, coordinates: Vector2):
	var plant: Plant = load("res://Plant.tscn").instantiate()
	plant.plant_data = plant_to_spawn
	add_child(plant)
	plant.initialize_with_position(coordinates)
	add_money(-selected_plant.cost)

func _handle_click():
	if not selected_plant:
		return
	
	if not can_place_plant:
		return
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	if not is_mouse_within_bounds(mouse_position):
		return
	
	mouse_position = _normalise_mouse_position_to_grid(mouse_position)
	var grid_coordinates: Vector2 = mouse_position
	grid_coordinates.x /= 128
	grid_coordinates.x -= 1
	grid_coordinates.y /= 128
	grid_coordinates.y -= 1
	
	if plant_grid[grid_coordinates.x][grid_coordinates.y]:
		return
	
	plant_grid[grid_coordinates.x][grid_coordinates.y] = true
	_buy_plant(selected_plant, mouse_position)
	can_place_plant = false
	selected_plant = null

func _handle_alt_click():
	if not selected_plant:
		return

	selected_plant = null

func _handle_wave():
	wave_tick_counter += 1
	if wave_tick_counter % 6 != 0:
		return
	_spawn_enemy()
	wave_enemy_counter += 1
	if wave_enemy_counter % ENEMY_WAVE_AMOUNT == 0:
		spawn_wave = false

func is_mouse_within_bounds(mouse_position: Vector2) -> bool:
	if mouse_position.x < 64 or mouse_position.x > (1280 - 64):
		return false
	
	if mouse_position.y < 64 or mouse_position.y > (768 - 64):
		return false
	
	return true

func _on_currency_timer_timeout():
	var currency = currency_scene.instantiate()
	var currency_spawn_location: PathFollow2D = $CurrencyPath/CurrencySpawnLocation
	currency_spawn_location.set_progress_ratio(randf())
	
	currency.global_position = currency_spawn_location.global_position
	add_child(currency)

func add_money(_money: int):
	money += _money
	Signals.money_changed.emit(money)

func select_plant(plant: PlantData):
	if money >= plant.cost:
		var plant_image: AnimatedSprite2D = load("res://PlantImage.tscn").instantiate()
		plant_image.sprite_frames = plant.sprite_frames
		add_child(plant_image)
		selected_plant = plant
		$PlantPlaceTimer.start()
		can_place_plant = false

func _on_plant_place_timer_timeout():
	can_place_plant = true

func _spawn_enemy():
	var enemy: Enemy = load("res://Enemy.tscn").instantiate()
	var enemy_spawn_path: Curve2D = $EnemySpawnPath.get_curve()
	
	var spawn_point = randi_range(0, 4)
	
	enemy.global_position = enemy_spawn_path.get_point_position(spawn_point)
	enemy.global_position.x += $EnemySpawnPath.global_position.x
	enemy.global_position.y += 128
	add_child(enemy)

func _on_enemy_spawn_timer_timeout():
	_spawn_enemy()
	
	if enemy_spawn_timer.wait_time >= 5:
		enemy_spawn_timer.wait_time -= 3
	enemies_spawned += 1
	
	if enemies_spawned % ENEMY_WAVE_THRESHOLD == 0:
		spawn_wave = true

func kill_plant(position: Vector2):
	position.x /= 128
	position.x -= 1
	position.y /= 128
	position.y -= 1
	plant_grid[position.x][position.y] = false
