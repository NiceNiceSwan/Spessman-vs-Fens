class_name Currency extends Node2D

const GRAVITY: int = 600

#var is_tweening: bool = false
var speed_x: float = 0
var speed_y: float = 50
var falling_distance: int

var lifetime: int = 15
@export var money: int = 25
## if true, this was spawned by the map and must fall down. 
## If false, it was spawned already on the ground.
@export var falling: bool = true

@onready var life_timer: Timer = $LifeTimer
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	falling_distance = randi_range(64, 704) + 32

func _process(delta) -> void:
	if falling:
		_handle_falling(delta)
		return
	
	_handle_jumping_out(delta)

func _handle_falling(delta: float) -> void:
	var moved_amount: float = speed_y * delta
	position.y += moved_amount
	
	if position.y < falling_distance:
		return
	
	position.y = falling_distance
	
	if lifetime > 0:
		life_timer.start(lifetime)
	set_process(false)

func _handle_jumping_out(delta: float) -> void:
	position.x += speed_x * delta
	position.y += speed_y * delta
	speed_y += GRAVITY * delta
	
	if position.y < falling_distance:
		return
	
	position.y = falling_distance
	
	if lifetime > 0:
		life_timer.start(lifetime)
	set_process(false)

func _on_click_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().current_scene.add_money(money)
		queue_free()

## Called when the currency was spawned on the ground, and must play a jump out animation
func fall_out():
	falling_distance = position.y + 32
	falling = false
	speed_y = -250
	var distance_to_the_side: float = randf_range(-64, 64)
	speed_x = distance_to_the_side / 1.5

func _on_life_timer_timeout():
	queue_free()
