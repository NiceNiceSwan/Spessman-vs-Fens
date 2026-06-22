class_name NewUnlock extends Control

var unlocked_plant: PlantData

@onready var description_label: Label = $VBoxContainer/PanelContainer/VBoxContainer/Description
@onready var texture: TextureRect = $VBoxContainer/PanelContainer/VBoxContainer/Texture

func _ready():
	description_label.text = unlocked_plant.description
	texture.texture = unlocked_plant.sprite_frames.get_frame_texture("default", 0)

func _on_continue_pressed():
	get_tree().change_scene_to_packed(load("res://Code/UI/LevelSelector.tscn"))
