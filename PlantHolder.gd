extends Control

#var cost: int
@export var plant: PlantData

func _ready():
	$Button/VBoxContainer/Cost.text = str(plant.cost)
	$Button/VBoxContainer/TextureRect.texture = plant.sprite_frames.get_frame_texture("default", 0)


func _on_button_pressed():
	get_tree().current_scene.select_plant(plant)
