## Resource describing the base attributes of a plant, such as name, max health and cost
class_name PlantData extends Resource

@export var ID: Enums.UNLOCKS = Enums.UNLOCKS.NONE
@export var name: String
@export var max_health: int = 5
@export var cost: int = 100
@export var sprite_frames: SpriteFrames
@export var plant_cooldown: float = 1
@export_multiline var description: String
@export var select_button_style: SelectButtonStyle = preload("uid://ceshgafsl8ihe")
