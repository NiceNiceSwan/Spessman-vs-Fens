class_name DefaultSelector extends Control

@onready var plants_hbox: HBoxContainer = $PlantsBox
@onready var money_amount: Label = $MoneyBox/VBoxContainer/MoneyAmount


func _ready() -> void:
	Signals.money_changed.connect(update_money)
	for plant_holder: PlantHolder in plants_hbox.get_children():
		if plant_holder.get_index() <= SaveData.unlocked_plants:
			plant_holder.set_visible(true)
		else:
			plant_holder.set_visible(false)

func update_money(money: int) -> void:
	money_amount.text = str(money)

func load_plant_data(plant_data: Array[PlantSelectButton]) -> void:
	for index in plant_data.size():
		var plant_holder: PlantHolder = plants_hbox.get_children()[index]
		plant_holder.plant = plant_data[index].plant_data
		plant_holder.plant_scene = plant_data[index].plant_scene
		plant_holder.reload()
