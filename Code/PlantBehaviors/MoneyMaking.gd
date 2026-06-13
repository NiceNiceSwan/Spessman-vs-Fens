extends Node

var money: int = 25
var money_delay: float = 10
@export var resource: MoneyMakers

signal behavior_action

func _ready():
	if not resource:
		push_warning("Instantiating money maker without any data!")
		$MoneyTimer.start(money_delay)
		return
	money = resource.money
	money_delay = resource.money_delay
	$MoneyTimer.start(money_delay)
	

func _on_money_timer_timeout():
	get_tree().current_scene.add_money(money)
	var money_delay_fraction = money_delay / 3
	var random_time = randf_range(-money_delay_fraction, money_delay_fraction)
	$MoneyTimer.set_wait_time(money_delay + random_time)
