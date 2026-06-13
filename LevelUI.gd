extends CanvasLayer

func _ready():
	Signals.money_changed.connect(update_money)

func update_money(money: int):
	$MarginContainer/VBoxContainer/Money.text = str(money)
