class_name NewUnlock extends Control

## Class representing the screen responsible for showing a newly unlocked 
## tower.

const LEVEL_SELECTOR_SCENE: PackedScene = preload("uid://bavn0ly1fcl5v")

## The data of the unlocked plant. Null by default, is supposed to be set by 
## the level on its conclusion.
var unlock: Unlockable

@onready var description_label: Label = $VBoxContainer/PanelContainer/VBoxContainer/Description
@onready var texture: TextureRect = $VBoxContainer/PanelContainer/VBoxContainer/Texture

func _ready() -> void:
	description_label.text = unlock.description
	texture.texture = unlock.texture

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_SELECTOR_SCENE)
