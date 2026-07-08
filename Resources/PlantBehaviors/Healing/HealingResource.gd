class_name HealingResource extends PlantBehaviorResource

@export var healing_delay: int = 15
## the health below which the tower in front of this must be to start healing
@export var healing_threshold: float = 0.8
@export var healing_projectile: HealingProjectilesResource
