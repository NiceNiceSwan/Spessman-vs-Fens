class_name Level extends Node2D

@export var level_data: LevelResource
@export var unlocks: PlantData

var money: int = 50
var selected_plant: PlantData
var selected_plant_scene: PackedScene
var selected_plant_index: int
var remove_plant: bool = false
var plant_grid: Array[Array]

var waves: Array[Wave]
var enemy_death_counter: int = 0
var wave_counter: int = -1
var enemy_sequence_counter: int = 0
var individual_enemy_counter: int = 0
var total_enemies_in_level: int = 0

var game_over_announced: bool = false
var should_show_new_unlock: bool = false

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var wave_timeout: Timer = $WaveTimeout
@onready var user_interface: UserInterface =  $LevelUI
@onready var enemy_spawn_path: Path2D = $EnemySpawnPath

func _ready():
	Signals.plant_selected.connect(select_plant)
	plant_grid.resize(9)
	for i in 9:
		plant_grid[i].resize(5)
	user_interface.update_money(money)
	
	if level_data:
		waves = level_data.waves
		unlocks = level_data.unlocks
	
	for wave in waves:
		for enemy_sequence in wave.enemy_sequences:
			wave.total_amount_of_enemies += enemy_sequence.amount
			total_enemies_in_level += enemy_sequence.amount
	
	user_interface.initialize_progress_bar(total_enemies_in_level)

func _normalise_mouse_position_to_grid(mouse_position: Vector2) -> Vector2:
	mouse_position.x += Defines.TILE_MAP_X_OFFSET
	mouse_position.y += Defines.TILE_MAP_Y_OFFSET
	mouse_position.x -= (int(mouse_position.x) % Defines.TILE_SIZE)
	mouse_position.y -= (int(mouse_position.y) % Defines.TILE_SIZE)
	return mouse_position

func _input(event: InputEvent):
	if event.is_action_pressed("alt_click"):
		_handle_alt_click()
	
	if event.is_action_pressed("click"):
		_handle_click()

func _buy_plant(plant_to_spawn: PlantData, coordinates: Vector2) -> Plant:
	var plant: Plant = selected_plant_scene.instantiate()
	plant.plant_data = plant_to_spawn
	plant.global_position = coordinates
	add_child(plant)
	add_money(-selected_plant.cost)
	plant.plant_died.connect(kill_plant)
	Signals.plant_placed.emit(selected_plant_index)
	return plant

func _handle_click():
	if not selected_plant and not remove_plant:
		return
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	if not is_mouse_within_bounds(mouse_position):
		return
	
	mouse_position = _normalise_mouse_position_to_grid(mouse_position)
	var grid_coordinates: Vector2 = mouse_position
	grid_coordinates.x /= Defines.TILE_SIZE
	grid_coordinates.x -= 1
	grid_coordinates.y /= Defines.TILE_SIZE
	grid_coordinates.y -= 1
	
	if plant_grid[grid_coordinates.x][grid_coordinates.y]:
		if remove_plant:
			var plant_to_remove: Plant = plant_grid[grid_coordinates.x][grid_coordinates.y]
			plant_to_remove.queue_free()
			remove_plant = false
			plant_grid[grid_coordinates.x][grid_coordinates.y] = null
			user_interface.on_plant_removed()
			$PlantRemoveSound.play()
		return
	
	if remove_plant:
		return
	
	plant_grid[grid_coordinates.x][grid_coordinates.y] = _buy_plant(selected_plant, mouse_position)
	selected_plant = null
	remove_plant = false

func _handle_alt_click():
	remove_plant = false
	user_interface.on_plant_removed()
	selected_plant = null

func is_mouse_within_bounds(mouse_position: Vector2) -> bool:
	if mouse_position.x < Defines.TILE_MAP_X_OFFSET or mouse_position.x > (1280 - 64):
		return false
	
	if mouse_position.y < Defines.TILE_MAP_Y_OFFSET or mouse_position.y > (768 - 64):
		return false
	
	return true

func _on_currency_timer_timeout():
	var currency = load("res://Code/Currency.tscn").instantiate()
	var currency_spawn_location: PathFollow2D = $CurrencyPath/CurrencySpawnLocation
	currency_spawn_location.set_progress_ratio(randf())
	
	currency.global_position = currency_spawn_location.global_position
	add_child(currency)

func add_money(_money: int):
	money += _money
	Signals.money_changed.emit(money)

func select_plant(plant: PlantData, plant_scene: PackedScene, plant_index: int):
	if money >= plant.cost:
		var plant_image: AnimatedSprite2D = load("res://PlantImage.tscn").instantiate()
		plant_image.sprite_frames = plant.sprite_frames
		add_child(plant_image)
		selected_plant = plant
		selected_plant_scene = plant_scene
		selected_plant_index = plant_index

func _spawn_enemy(enemy_scene: PackedScene, enemy_data: EnemyResource):
	if enemy_scene == null:
		enemy_scene = load("res://Code/Enemy.tscn")
	
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.enemy_resource = enemy_data
	var enemy_spawn_curve: Curve2D = enemy_spawn_path.get_curve()
	
	var spawn_point = randi_range(0, 4)
	
	enemy.global_position = enemy_spawn_curve.get_point_position(spawn_point)
	enemy.global_position.x += enemy_spawn_path.global_position.x
	enemy.global_position.y += 128
	enemy.died.connect(_on_enemy_death)
	enemy.game_over.connect(game_over)
	add_child(enemy)
	enemy.initialize()

func _on_enemy_spawn_timer_timeout():
	enemy_spawn_timer.set_wait_time(0.25)
	var wave: Wave = waves[wave_counter]
	var enemy_sequence: EnemySequence = wave.enemy_sequences[enemy_sequence_counter]
	if individual_enemy_counter < enemy_sequence.amount:
		individual_enemy_counter += 1
		_spawn_enemy(enemy_sequence.enemy, enemy_sequence.enemy_data)
		return
	
	individual_enemy_counter = 0
	if enemy_sequence_counter < wave.enemy_sequences.size() - 1:
		enemy_sequence_counter += 1
		enemy_sequence =  wave.enemy_sequences[enemy_sequence_counter]
		_spawn_enemy(enemy_sequence.enemy, enemy_sequence.enemy_data)
		individual_enemy_counter += 1
		return
	
	enemy_sequence_counter = 0
	enemy_spawn_timer.stop()
	wave_timeout.start()

func kill_plant(_position: Vector2):
	_position.x /= 128
	_position.x -= 1
	_position.y /= 128
	_position.y -= 1
	plant_grid[_position.x][_position.y] = false

func _on_level_ui_plant_remover_selected() -> void:
	remove_plant = true

func _on_enemy_death():
	enemy_death_counter += 1
	user_interface.update_progress_bar(enemy_death_counter)
	if enemy_death_counter == total_enemies_in_level:
		_win()

func _on_wave_timeout_timeout():
	if wave_counter >= waves.size() - 1:
		return
	
	wave_counter += 1
	if waves[wave_counter].major_wave:
		user_interface.announce_wave()
		enemy_spawn_timer.set_wait_time(3)
	
	enemy_spawn_timer.start()

func game_over() -> void:
	if game_over_announced:
		return
	
	game_over_announced = true
	user_interface.announce_defeat()

func _win() -> void:
	if unlocks != null and SaveData.unlocked_plants < unlocks.ID:
		SaveData.unlocked_plants = unlocks.ID
		should_show_new_unlock = true
	elif unlocks == null:
		SaveData.unlocked_plants = Enums.UNLOCKS.ALL
		should_show_new_unlock = false
	SaveData.save_game()
	user_interface.announce_victory()

func _on_level_ui_won_timer_expired():
	if should_show_new_unlock:
		var new_unlock: NewUnlock = load("res://Code/UI/NewUnlock.tscn").instantiate()
		new_unlock.unlocked_plant = unlocks
		get_tree().root.add_child(new_unlock)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = new_unlock
		return
	get_tree().change_scene_to_packed(load("res://Code/UI/LevelSelector.tscn"))
