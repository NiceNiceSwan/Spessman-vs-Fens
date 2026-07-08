class_name NewUnlock extends Control

var unlock: Unlockable

@onready var description_label: Label = $VBoxContainer/PanelContainer/VBoxContainer/Description
@onready var texture: TextureRect = $VBoxContainer/PanelContainer/VBoxContainer/Texture

func _ready():
	description_label.text = unlock.description
	#texture.texture = unlock.sprite_frames.get_frame_texture("default", 0)
	texture.texture = unlock.texture

func _on_continue_pressed():
	get_tree().change_scene_to_packed(preload("uid://bavn0ly1fcl5v"))
