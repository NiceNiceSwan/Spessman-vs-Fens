class_name Currency extends Node2D

@export var speed: int = 50
@export var falling_distance: int
@export var lifetime: int = 5
@export var money: int = 25

func _ready():
	falling_distance = randi_range(64, 704) + 32

func _process(delta):
	var moved_amount: float = speed * delta
	position.y += moved_amount
	
	if position.y < falling_distance:
		return
	
	position.y = falling_distance
	
	if lifetime > 0:
		$LifeTimer.start(lifetime)
	set_process(false)

func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_tree().current_scene.add_money(money)
		queue_free()


func _on_life_timer_timeout():
	queue_free()
