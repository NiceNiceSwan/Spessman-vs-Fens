class_name MoneyMakers extends PlantBehaviorResource

@export var money: int = 25
@export var currency_texture: Texture2D
@export var automatic_generation: bool = true
@export_range(0.01, 100, 0.01) var money_delay: float = 10
