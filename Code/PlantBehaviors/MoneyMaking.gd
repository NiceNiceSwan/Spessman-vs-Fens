class_name MoneyMaking extends PlantBehavior

var currency = load("res://Code/Currency.tscn")

var money: int = 25
var money_delay: float = 10
## Whether this generates money on a timer, or does it have to be triggered upon receiving a signal
var automatic_generation: bool = true
#var global_position: Vector2
var currency_texture: Texture2D

@onready var money_timer: Timer = $MoneyTimer

@export var resource: MoneyMakers

signal made_money

func _ready():
	if not resource:
		push_warning("Instantiating money maker without any data!")
		money_timer.start(money_delay)
		return
	money = resource.money
	money_delay = resource.money_delay
	global_position = get_parent().global_position
	currency_texture = resource.currency_texture
	automatic_generation = resource.automatic_generation
	if automatic_generation:
		money_timer.start(money_delay)

func _on_money_timer_timeout():
	#get_tree().current_scene.add_money(money)
	create_money()
	var money_delay_fraction = money_delay / 3
	var random_time = randf_range(-money_delay_fraction, money_delay_fraction)
	money_timer.set_wait_time(money_delay + random_time)

func create_money():
	var currency_object: Currency = currency.instantiate()
	currency_object.global_position = global_position
	get_tree().current_scene.add_child(currency_object)
	currency_object.sprite.texture = currency_texture
	currency_object.money = money
	currency_object.fall_out()
